
```jenkins
pipeline {
    agent any

    stages {
        stage('Hack the planet') 
        {
            steps {
                script {
                    def pass;
                    def user;
                }
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '<GUID>', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
                    script {
                        pass = env.PASSWORD;
                        user = env.USERNAME;
                    }
                    echo ("Username: ${USERNAME}")
                    echo ("Password: ${PASSWORD}")
                }
                echo ("user: ${user}")
                echo ("password: ${pass}")
            }   
        }
    }
}
```
