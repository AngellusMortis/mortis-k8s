locals {
    tags = {
        wl = ["wl"]
        dc = ["dc"]

        k8s = ["k8s"]

        control = ["control"]
        debug = ["debug"]
        home = ["home"]
        media = ["media"]
        media_ingest = ["media", "media-ingest"]
        metrics = ["control", "metrics"]
    }
}
