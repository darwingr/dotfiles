# .zprofile
#
# Sourced on a login session directly before .zshrc is sourced.
# Use same way as .zlogin (which sources after .zshrc).
#
# Should be used for:
#   - setting the terminal type
#   - running external commands (fortune, msgs)
#
# Should NOT be used for:
#   - alias definitions
#   - options
#   - environment variable settings
#   => Should NOT change shell environment at all
echo "Sourcing ~/.zprofile"
