package com.github.rmtmckenzie.qrmobilevision;
import java.util.Map;
import java.util.List;

public interface QrReaderCallbacks {
    void qrRead(Map<String, Object> data);
}
