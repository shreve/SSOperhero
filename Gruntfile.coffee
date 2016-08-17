module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      compile:
        options:
          bare: true
        files:
          'priv/static/js/client.js': 'web/static/js/client.coffee'
          'priv/static/js/provider.js': 'web/static/js/provider.coffee'

    watch:
      scripts:
        files: ['web/static/js/*'],
        tasks: ['coffee:compile']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask('default', ['coffee'])
