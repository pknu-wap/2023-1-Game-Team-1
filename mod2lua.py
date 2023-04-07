import shutil
import os
import re

doubleQuot = 'TMP_DOUBLE_QUOT'
newline = 'TMP_NEWLINE'
tab = 'TMP_TAB'


def ModToTxt(modFileName):
    txtFileName = modFileName.replace('.mod', '.txt')
    with open(modFileName, 'r', encoding='utf-8', errors='ignore') as mod, \
            open(txtFileName, 'w', encoding='utf-8') as txt:
        for line in mod:
            line = ''.join(c for c in line if 0 < ord(c) < 127 or ord(c) > 160)
            txt.write(line)
    return txtFileName


def parseProperties(properties):
    content = '[Properties]\n\n'

    for property in re.findall('{.*?}', properties):
        type = re.search('"Type":"(.*?)"', property).group(1)
        name = re.search('"Name":"(.*?)"', property).group(1)
        value = re.search('"DefaultValue":"(.*?)"', property).group(1)

        if type == "dictionary" or type == "array":
            value = value.replace('|', ', ')
            type += '<'+value+'>'
            value = ''
        elif type == "Entity":
            value = ''
        else:
            value = '= '+value

        content += type+' '+name+' '+value+'\n'

    return content


def parseMethods(methods):
    content = '\n\n[Methods]\n\n'

    for method in re.findall('{"Return".*?"Scope".*?}', methods):
        type = re.search('"Type":"(.*?)"', method).group(1)
        name = re.search('"Scope".*?"Name":"(.*?)"', method).group(1)
        arguments = ""
        if method.find('"Arguments":[') != -1:
            args = re.search(
                '"Arguments":\[(.*?)\],"Code"', method).group(1)
            for arg in re.findall('{.*?"Name".*?}', args):
                argType = re.search('"Type":"(.*?)"', arg).group(1)
                argName = re.search('"Name":"(.*?)"', arg).group(1)
                arguments += ', '+argType + ' '+argName
            arguments = arguments.replace(', ', '', 1)

        code = re.search('"Code":"(.*?)"', method).group(1)
        code = tab + code
        code = code.replace(newline, newline+tab)

        content += type + ' ' + name + \
            '('+arguments+') {\n' + code + '\n}\n\n\n'

    return content


def parseScript(folderName, line):
    scriptName = re.search('"Name":"(.*?)"', line).group(1)

    properties = re.search('"Properties".*"Methods"', line).group(0)
    content = parseProperties(properties)

    methods = re.search('"Methods".*"EntityEventHandlers"', line).group(0)
    content += parseMethods(methods)

    content = content.replace(doubleQuot, '"')
    content = content.replace(newline, '\n')
    content = content.replace(tab, '\t')

    with open(folderName+'/'+scriptName+'.lua', 'w', encoding="utf-16") as script:
        script.write(content)


def TxtToLua(txtFileName):
    with open(txtFileName, 'r', encoding='utf-8') as txt:
        folderName = txtFileName.replace('.txt', '')
        shutil.rmtree(folderName)
        os.mkdir(folderName)
        for line in txt:
            line = line.replace('\\"', doubleQuot)
            line = line.replace('\\n', newline)
            line = line.replace('\\t', tab)
            if '"ScriptVersion"' in line:
                parseScript(folderName, line)


def ModToLua(modFileName):
    txtFileName = ModToTxt(modFileName)
    TxtToLua(txtFileName)


ModToLua('input.mod')
