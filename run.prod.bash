#!/bin/sh

export PORT=4000
export DATABASE_URL="ecto://postgres:postgres@localhost/mango_prod"
export SECRET_KEY_BASE=oBdDRSBdnRWLiQNv1f/P4kHivyFL7bvEWJEYgKCp0wInb9/WkS8ZeJsKXHwWFXVr
mango="./_build/prod/rel/mango/bin/mango"

$mango migrate && $mango seeds && $mango foreground
