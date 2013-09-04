path = require 'path'

module.exports = (grunt) ->

  seleniumPath = path.resolve 'selenium'

  grunt.initConfig
    env:
      test:
        PATH: "#{seleniumPath}:process.env.PATH"

    connect:
      server:
        options:
          keepalive: true
          port: 9001
          base: 'public'

    cucumberjs:
      files: 'features/*.feature'

    less:
      production:
        options:
          paths:       ['css']
          yuicompress: true
        files: [
          {
            src:  'css/index.less'
            dest: 'public/application.css'
          }
        ]

    copy:
      main:
        files: [
          { expand: true, cwd: 'vendor/jquery/', src: ['**'], dest: 'public/vendor/jquery' },
          { expand: true, cwd: 'vendor/angular/', src: ['**'], dest: 'public/vendor/angular' }
        ]

    shell:
      selenium:
        command: 'java -jar selenium/selenium-server-standalone-*.jar -Dwebdriver.chrome.driver=./selenium/chromedriver'
        options:
          stdout: true

    watch:
      files: ['app/**/*.coffee']
      tasks: 'coffee'

    coffee:
      compile:
        options:
          bare: true
        src: ['app/**/*.coffee']
        dest: 'public/application.js'
        ext: '.js'

    concurrent:
      target:
        tasks: ['connect', 'watch', 'shell:selenium', 'less', 'copy']

  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-concurrent'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-cucumber'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-shell'

  grunt.registerTask 'default', ['concurrent:target']

  grunt.registerTask 'test', [
    'env:test'
    'cucumberjs'
  ]
