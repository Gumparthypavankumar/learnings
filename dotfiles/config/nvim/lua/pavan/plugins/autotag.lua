local autotag_status, autotag = pcall(require, "nvim-ts-autotag")
if not autotag_status then
  return
end

autotag.setup()
