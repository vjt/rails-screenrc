#!/bin/sh

# parse args
args=`getopt ris:d:u: $*`
if test $? != 0; then
  echo "Usage: $0 [-r] [-i] [-s secs] [-d chdir] [-u umask] [--] command args..."
  exit
fi
set -- $args

# defaults
sleep=2
umask=022
chdir=
rvm=
int=

for i; do
  case "$i" in
    -r) rvm=1;    shift;;
    -i) int=1;    shift;;

    -s) sleep=$2; shift 2;;
    -d) chdir=$2; shift 2;;
    -u) umask=$2; shift 2;;

    --) shift; cmd="$@"
    break;;
  esac
done

# load RVM
if test "$rvm" -a -f ~/.rvm/scripts/rvm; then
  echo '** Loading RVM'
  source ~/.rvm/scripts/rvm
fi

# chdir
if test "$chdir"; then
  cd $chdir # Triggers .rvmrc hook
elif test "$rvm" -a -f .rvmrc; then
  echo "** Sourcing `pwd`/.rvmrc"
  source .rvmrc
fi

# execute
umask $umask
echo "** Executing $cmd in `pwd`"
while true; do
  if test "$int"; then
    bash --norc --noprofile -i -c "$cmd; exit"
  else
    $cmd
  fi

  echo "** '$cmd': exit $?"
  echo "** sleeping $sleep secs..."

  sleep $sleep
done
