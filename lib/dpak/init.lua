local registeredPackages = {}
for i, v in ipairs(fs.list('prg')) do
    if not fs.isDir(fs.combine('prg', v)) then
        table.insert(registeredPackages, v)
    end
end
local registeredLibraries = {}
for i, v in ipairs(fs.list('lib')) do
    if not fs.isDir(fs.combine('lib', v)) then
        table.insert(registeredLibraries, v)
    end
end

local function init()
    -- add /prg to shell path
    shell.setPath(shell.path() .. ':/prg')

    -- add /prg/.help to help path
    help.setPath(help.path() .. ':/prg/.help')
end

-- require functions
local rq = {
    program = function(program)
        if fs.exists(fs.combine('prg', program .. '.lua')) then
            return require('.prg.' .. program)
        else
            term.setTextColor(colors.red)
            print('Required program ' .. program .. ' not found.')
            term.setTextColor(colors.white)
            print('TODO: check if program exists in repository, and ask to install')
        end
    end,

    library = function(library)
        if fs.exists(fs.combine('lib', library .. '.lua')) or (fs.exists(fs.combine('lib', library)) and fs.isDir(fs.combine('lib', library))) then
            return require('.lib.' .. library)
        else
            term.setTextColor(colors.red)
            print('Required library ' .. library .. ' not found.')
            term.setTextColor(colors.white)
            print('TODO: check if library exists in repository, and ask to install')
        end
    end,
}
rq.prog = rq.program
rq.prg = rq.program
rq.lib = rq.library

-- package installer functions
local function installFromFile(file)
    local dprgFile = fs.open(file, 'r')
    local dprg = textutils.unserialize(dprgFile.readAll())
    dprgFile.close()

    local archivePath = fs.combine('tmp', 'dprg', fs.getName(file) .. '.binarc')
    local archiveFile = fs.open(archivePath, 'w')
    archiveFile.write(dprg.archive)
    archiveFile.close()

    shell.execute('/prg/binarc', 'extract', archivePath, '/prg')

    fs.delete(archivePath)

    local helpFile = fs.open('/prg/.help/'..dprg.id..'.txt', 'w')
    helpFile.write(dprg.help)
    helpFile.close()
end

return {
    version = '0.1.0',

    registeredPackages = registeredPackages,
    registeredLibraries = registeredLibraries,
    init = init,

    require = rq,

    installFromFile = installFromFile,
}