pipeline {
    agent any

     environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "35.224.117.172:8081"
        NEXUS_REPOSITORY = "maven-snapshots"
        NEXUS_CREDENTIAL_ID = "nexus-integration"
     }

     stages {
        stage('git clone') {
            steps{
                git branch: 'main', url: 'https://github.com/Tejaswi53/spring-petclinic-teja.git'
            }
        }

        stage('maven build') {
            steps{
                script {
                    withSonarQubeEnv('My SonarQube Server') {
                        sh 'mvn clean package sonar:sonar'
                    }
                }             
            }
        }

        stage ('quality check') {
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        waitForQualityGate abort
                    }

                }
            }
        }

        stage('uploading to nexus') {
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
        }
     }
}
