pipeline {
    agent any
     tools {
        maven "maven3"
     }

     /*environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "35.208.25.168:8081"
        NEXUS_REPOSITORY = "maven-snapshots"
        NEXUS_CREDENTIAL_ID = "nexus-integration"
     }*/

     stages {
        stage('git clone') {
            steps {
                git branch: 'main', url: 'https://github.com/Tejaswi53/spring-petclinic-teja.git'
            }
        }

        stage('maven build') {
            steps {
                script {
                    
                    sh 'mvn install -DskipTests'
                    
                }             
            }
        }

        /*stage('quality check') {
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }

                }
            }
        }*/

        /*stage('uploading to nexus') {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob}"
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version: ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier:'',
                                file: artifactPath,
                                type: pom.packaging],

                                [artifactId: pom.artifactId,
                                classifier:'',
                                file: "pom.xml",
                                type: "pom"]
                            ]

                        );

                    } else {
                        echo "File: ${artifactPath} is not found";
                    }
                }
            }
        }*/

        stage('renaming') {
            steps {
                script {
                     def pom = readMavenPom file: "pom.xml";
                     def artifactId = pom.artifactId
                        //ls ${WORKSPACE}/target
                     sh "mv ${WORKSPACE}/target/spring-petclinic-3.4.0-SNAPSHOT.jar ${artifactId}-${BUILD_NUMBER}-${env.BRANCH_NAME}.jar"
                       // ls ${WORKSPACE}/target
                        //echo "${WORKSPACE}"
                                      
                }
            }
        }

        stage('docker build') {
            steps {
                script {
                    sh '''
                      pwd
                      docker build --build-arg source_jar=spring-petclinic-${BUILD_NUMBER}-${BRANCH_NAME}.jar -t spring-petclinicapp:${BUILD_NUMBER} .
                     
                     '''
                }
            }
        }

        stage('push image') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                 // some block
                
                  script {
                    sh '''
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 976193221273.dkr.ecr.us-east-1.amazonaws.com
                    docker tag spring-petclinicapp:${BUILD_NUMBER} 976193221273.dkr.ecr.us-east-1.amazonaws.com/spring-petclinic:${BUILD_NUMBER}
                    docker push 976193221273.dkr.ecr.us-east-1.amazonaws.com/spring-petclinic:${BUILD_NUMBER}
                    '''
                  }
                }
            }
        }

        stage('integrating eks cluster') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: ' petclinic-cluster', contextName: '', credentialsId: 'k8s-serviceAccount', namespace: 'petclinic', serverUrl: 'https://9559D8ABB0E217B8F6BF6254BAA6DF74.gr7.us-east-2.eks.amazonaws.com']]) {
                 // some block
                  script {
                    sh ' kubectl get nodes '
                  }
                }
            }
        }
    }
}
