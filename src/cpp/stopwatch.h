#ifndef stopwatch_h_
#define stopwatch_h_

#include <cassert>
#include <sys/time.h>

class StopWatch {
public:
  long currentTimeMillis() {
    struct timeval tv;
    struct timezone tz;
    int res = gettimeofday(&tv, &tz);
    assert(res == 0);
    return tv.tv_sec*1000 + tv.tv_usec / 1000;
  }

  void start() {
    fStart = currentTimeMillis();
  }

  long stop() {
    fEnd = currentTimeMillis();
  }

  long delta() {
    return fEnd - fStart;
  }

private:
  long fStart;
  long fEnd;
};

#endif
