package com.trained.project.trainedproject;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TrainedProjectApplication {

    public static void main(String[] args) {
        SpringApplication.run(TrainedProjectApplication.class, args);
    }

    public int size() {
        long n = sumCount();
        return ((n < 0L) ? 0 : (n > (long) Integer.MAX_VALUE) ? Integer.MAX_VALUE : (int) n);
    }
    // 使用 baseCount 和 CounterCell 数组进行计数
    private transient volatile long baseCount;
    private transient volatile CounterCell[] counterCells;

    final long sumCount() {
        CounterCell[] as = counterCells;
        CounterCell a;
        long sum = baseCount;
        if (as != null) {
            for (int i = 0; i < as.length; ++i) {
                if ((a = as[i]) != null) sum += a.value;
            }
        }
        return sum;
    }


}
