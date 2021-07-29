local packageInjector = {}

function packageInjector.require(package, useMock)
    if ((not useMock) or not (os.getenv("HOME") == nil)) then
        return require(package)
    else
        return require("Mocks." .. package)
    end
end

return packageInjector