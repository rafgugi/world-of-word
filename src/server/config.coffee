yaml = require 'js-yaml'
path = require 'path'
fs = require 'fs'

ymlFile = fs.readFileSync(path.join(__dirname, '../../config.yml'), 'utf8')
config = yaml.load ymlFile
module.exports = config