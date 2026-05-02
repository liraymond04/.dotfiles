-- installing jdtls is required, on Arch this is done through the AUR
local config = {
  cmd = { "jdtls" },
  root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
}

local status_jdtls_ok, jdtls = pcall(require, "jdtls")
if not status_jdtls_ok then
  return
end
jdtls.start_or_attach(config)
