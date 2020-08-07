pipeline {
  agent any
  stages {
    stage('Test Stage') {
      steps {
        writeFile(file: 'test.txt', text: 'big wheel', encoding: 'UTF-8')
      }
    }

    stage('final') {
      steps {
        archiveArtifacts 'test.txt'
        sleep(unit: 'HOURS', time: 4)
      }
    }

  }
}