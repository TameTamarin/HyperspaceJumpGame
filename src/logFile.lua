function logFile()
    return {
        enabled = false,
        dir = "",
        LogPath = "",
        fileName = "",
        folderCreated = false,
        appName = "",

        init = function (self, fileName, gameName)
            -- Crate log file and write the time and date it was started
            if self.enabled then
                self.appName = gameName
                self.fileName = gameName .. "_" .. fileName
                local file = love.filesystem.newFile(self.fileName, "w")
                file:write("Start of log:  " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
                file:close()
            end
        end,

        write = function(self, data)
            if self.enabled then
                love.filesystem.append(self.fileName, data .. "\n")
        
            end
        end,

        close = function(self)
            if self.enabled then
                -- Write that the log file has been closed on func call
                love.filesystem.append(self.fileName, self.appName .. " Exiting")
        
            end
        end
    }
end

return logFile
