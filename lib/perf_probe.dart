class PerfProbe {
  static int handleDataCount = 0;
  static int handleDataTotalUs = 0;
  static int handleDataMaxUs = 0;
  static int tcpFlushCount = 0;
  static int tcpFlushTotalUs = 0;
  static int tcpFlushMaxUs = 0;
  static int chunkCount = 0;
  static int chunkBytes = 0;
  static int chunkLines = 0;
  static int backlogEvents = 0;
  static int pendingHandleData = 0;
  static int isolateSent = 0;
  static int isolateRecv = 0;
  static int isolateTotalUs = 0;
  static int isolateMaxUs = 0;
  static int isolatePending = 0;
  static void resetSample() {
    handleDataCount = 0;
    handleDataTotalUs = 0;
    handleDataMaxUs = 0;
    tcpFlushCount = 0;
    tcpFlushTotalUs = 0;
    tcpFlushMaxUs = 0;
    chunkCount = 0;
    chunkBytes = 0;
    chunkLines = 0;
    backlogEvents = 0;
    isolateSent = 0;
    isolateRecv = 0;
    isolateTotalUs = 0;
    isolateMaxUs = 0;
  }

  static void recordHandleData(int us) {
    handleDataCount++;
    handleDataTotalUs += us;
    if (us > handleDataMaxUs) handleDataMaxUs = us;
  }

  static void recordTcpFlush(int us) {
    tcpFlushCount++;
    tcpFlushTotalUs += us;
    if (us > tcpFlushMaxUs) tcpFlushMaxUs = us;
  }

  static void recordChunk(int bytes, int lines) {
    chunkCount++;
    chunkBytes += bytes;
    chunkLines += lines;
  }

  static void recordBacklog() {
    backlogEvents++;
  }
}
