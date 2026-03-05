# AWS profile switcher with SSO login by default
function profile() {
    # parse flags upfront
    local do_logout=false
    local no_login=false
    local do_relogin=false

    for arg in "$@"; do
        case "$arg" in
            --logout|-l)   do_logout=true ;;
            --no-login|-n) no_login=true ;;
            --relogin|-r)  do_relogin=true ;;
            --help|-h)
                echo "Usage: profile [options]"
                echo ""
                echo "Options:"
                echo "  -l, --logout     Log out of the current AWS SSO profile and unset env vars"
                echo "  -n, --no-login   Switch profile without triggering SSO login"
                echo "  -r, --relogin    Re-login to the current AWS SSO profile without switching"
                echo "  -h, --help       Show this help message"
                return 0
                ;;
            *)
                echo "Unknown option: $arg"
                echo "Run 'profile --help' for usage."
                return 1
                ;;
        esac
    done

    # handle relogin
    if $do_relogin; then
        if [[ -z "$AWS_PROFILE" ]]; then
            echo "No active AWS profile to re-login to"
            return 1
        fi
        echo "Logging in to AWS SSO for profile: $AWS_PROFILE"
        aws sso login --profile "$AWS_PROFILE"
        return 0
    fi

    # handle logout
    if $do_logout; then
        if [[ -z "$AWS_PROFILE" ]]; then
            echo "No active AWS profile to log out from"
            return 1
        fi
        echo "Logging out of AWS SSO for profile: $AWS_PROFILE"
        aws sso logout --profile "$AWS_PROFILE"
        unset AWS_PROFILE
        unset ENV_NAME
        echo "Unset AWS_PROFILE and ENV_NAME"
        return 0
    fi

    # ensure AWS config exists
    local aws_config_file="$HOME/.aws/config"
    if [[ ! -f "$aws_config_file" ]]; then
        echo "AWS config file not found at $aws_config_file"
        return 1
    fi

    # pick a profile via fzf
    local choice
    choice=$(aws configure list-profiles | sort | fzf --prompt "Choose active AWS profile:") || return

    export AWS_PROFILE="${choice:-default}"

    # propagate any custom env_name
    local env_name
    env_name=$(aws configure get env_name --profile "$AWS_PROFILE")
    if [[ -z "$env_name" ]]; then
        echo "Warning: no env_name configured for profile '$AWS_PROFILE', ENV_NAME will be unset"
        unset ENV_NAME
    else
        export ENV_NAME="$env_name"
    fi

    # skip login if requested
    if $no_login; then
        echo "Skipping SSO login for profile: $AWS_PROFILE"
        return 0
    fi

    # check whether credentials are still valid
    if aws sts get-caller-identity --profile "$AWS_PROFILE" >/dev/null 2>&1; then
        echo "AWS credentials valid for profile: $AWS_PROFILE"
    else
        echo "Logging in to AWS SSO for profile: $AWS_PROFILE"
        aws sso login --profile "$AWS_PROFILE"
    fi
}
