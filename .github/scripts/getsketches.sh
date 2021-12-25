function count_sketches() # count_sketches <examples-path> <target-mcu>
{
  local examples="$1"
  local target="$2"
  rm -rf sketches.txt
  if [ ! -d "$examples" ]; then
    touch sketches.txt
    return 0
  fi

  local sketches=$(find $examples -name *.ino)
  local sketchnum=0
  for sketch in $sketches; do
    local sketchdir=$(dirname $sketch)
    local sketchdirname=$(basename $sketchdir)
    local sketchname=$(basename $sketch)
    if [[ "$sketchdirname.ino" != "$sketchname" ]]; then
        continue
    elif [[ -f "$sketchdir/.skip.$target" ]]; then
        continue
    else
      echo $sketch >> sketches.txt
      sketchnum=$(($sketchnum + 1))
    fi
  done
  return $sketchnum
}

function build_sketches() # <target-mcu> <examples-path> <chunk> <total-chunks>
{
  local target="$1"
  local examples=$2
  local chunk_idex=$3
  local chunks_num=$4

  count_sketches "$examples" "$target"
  local sketchcount=$?
  local sketches=$(cat sketches.txt)
  rm -rf sketches.txt

  local chunk_size=$(( $sketchcount / $chunks_num ))
  local all_chunks=$(( $chunks_num * $chunk_size ))
  if [ "$all_chunks" -lt "$sketchcount" ]; then
    chunk_size=$(( $chunk_size + 1 ))
  fi

  local start_index=0
  local end_index=0
  if [ "$chunk_idex" -ge "$chunks_num" ]; then
    start_index=$chunk_idex
    end_index=$sketchcount
  else
    start_index=$(( $chunk_idex * $chunk_size ))
    if [ "$sketchcount" -le "$start_index" ]; then
      return 0
    fi

    end_index=$(( $(( $chunk_idex + 1 )) * $chunk_size ))
    if [ "$end_index" -gt "$sketchcount" ]; then
      end_index=$sketchcount
    fi
  fi

  local start_num=$(( $start_index + 1 ))
  local sketchnum=0
  rm -rf build_list.txt
  for sketch in $sketches; do
      local sketchdir=$(dirname $sketch)
      local sketchdirname=$(basename $sketchdir)
      local sketchname=$(basename $sketch)
      if [ "${sketchdirname}.ino" != "$sketchname" ] \
      || [ -f "$sketchdir/.skip.$target" ]; then
          continue
      fi
      sketchnum=$(($sketchnum + 1))
      if [ "$sketchnum" -le "$start_index" ] \
      || [ "$sketchnum" -gt "$end_index" ]; then
        continue
      fi
      echo ${sketch} >> build_list.txt
      local result=$?
      if [ $result -ne 0 ]; then
          return $result
      fi
  done
  return 0
}

target=`echo $1 | cut -d":" -f3`
build_sketches $target libraries $2 $3
