(import <nixpkgs> {}).writeTextFile {
    name = "tmux-session";
    text = ''
        #!/usr/bin/env bash

        trim() { echo $1; }

        # Make sure we are not already in a tmux session
        if [ -z "$TMUX" ]; then
            base_session=`whoami`
            tmux_nb=$(trim `tmux ls | grep "^$base_session" | wc -l`)
            if [ "$tmux_nb" = "0" ]; then
                echo "Launching tmux base session $base_session ..."
                tmux -2 new-session -s $base_session
            else
                # Attach to the new session & kill it once orphaned
                tmux -2 attach-session -t $base_session
            fi
        fi
    '';
    executable = true;
    destination = "/usr/bin/tmux-session";
}
