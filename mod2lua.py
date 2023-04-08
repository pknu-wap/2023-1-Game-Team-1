import sys
import shutil
import os
import re

doubleQuot = 'TMP_DOUBLE_QUOT'
newline = 'TMP_NEWLINE'
tab = 'TMP_TAB'
execSpace = ['Default', 'Server Only', 'Client Only', 'Unknown Space 3',
             'Unknown Space 4', 'Server', 'Client', 'Unknown Space 7', 'Unknown Space 8', 'Multicast']


def ModToTxt(modFileName):
    txtFileName = modFileName.replace('.mod', '.txt')
    with open(modFileName, 'r', encoding='utf-8', errors='ignore') as mod, \
            open(txtFileName, 'w', encoding='utf-8') as txt:
        for line in mod:
            line = ''.join(c for c in line if 0 < ord(c) < 127 or ord(c) > 160)
            txt.write(line)
    return txtFileName


def parseProperties(properties):
    content = '--Properties--\n\n'

    for property in re.findall('{.*?}', properties):
        type = re.search('"Type":"(.*?)"', property).group(1)
        name = re.search('"Name":"(.*?)"', property).group(1)
        value = re.search('"DefaultValue":"(.*?)"', property).group(1)

        if type == "dictionary" or type == "array":
            value = value.replace('|', ', ')
            type += '<'+value+'>'
            value = ''
        elif type == "Entity" or type == "Component":
            value = ''
        else:
            value = '= '+value

        content += type+' '+name+' '+value+'\n'

    return content


def parseMethods(methods):
    content = '\n\n--Methods--\n\n'

    for method in re.findall('{"Return".*?"Scope".*?}', methods):
        space = re.search('"ExecSpace":(.*?),', method).group(1)
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
        code = code.replace(newline, newline+tab)

        content += '[' + execSpace[int(space)] + ']\n' + type + ' ' + name + \
            '(' + arguments + ')\n{\n' + tab + code + '\n}\n\n\n'

    return content


def parseEvents(events):
    content = '\n\n--Events--\n\n'

    for event in re.findall('{"Name".*?"ExecSpace".*?}', events):
        space = re.search('"ExecSpace":(.*?)}', event).group(1)
        type = re.search('"Name":"(.*?)"', event).group(1)
        argType = re.search('"EventName":"(.*?)"', event).group(1)
        code = re.search('"Code":"(.*?)"', event).group(1)
        code = code.replace(newline, newline+tab)
        content += '[' + execSpace[int(space)] + ']\n' + type + \
            '('+argType+' event)\n{\n' + tab + code + '\n}\n\n\n'

    return content


def parseScript(folderName, line):
    scriptName = re.search('"Name":"(.*?)"', line).group(1)

    properties = re.search('"Properties".*"Methods"', line).group(0)
    content = parseProperties(properties)

    methods = re.search('"Methods".*"EntityEventHandlers"', line).group(0)
    content += parseMethods(methods)

    events = re.search('"EntityEventHandlers".*', line).group(0)
    content += parseEvents(events)

    content = content.replace(doubleQuot, '"')
    content = content.replace(newline, '\n')
    content = content.replace(tab, '\t')

    with open(folderName+'/'+scriptName+'.lua', 'w', encoding="utf-16") as script:
        script.write(content)


def TxtToLua(txtFileName):
    with open(txtFileName, 'r', encoding='utf-8') as txt:
        folderName = txtFileName.replace('.txt', '')
        if os.path.exists(folderName):
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


ModToLua(sys.argv[1])
