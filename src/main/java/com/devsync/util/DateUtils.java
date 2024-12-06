package com.devsync.util;

import com.devsync.domain.entity.Task;

import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;

public class DateUtils {

    public static String formatDate(Date date) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        return formatter.format(date);
    }


    public static long calculateRemainingDays(Task task) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime dueDate = task.getDueDate();

        return Duration.between(now, dueDate).toDays();
    }


    public static String calculateHoursAgo(LocalDateTime createdAt) {
        LocalDateTime now = LocalDateTime.now();
        long minutes = ChronoUnit.MINUTES.between(createdAt, now);
        long hours = ChronoUnit.HOURS.between(createdAt, now);
        long days = ChronoUnit.DAYS.between(createdAt, now);

        if (minutes < 1) {
            return "just now";
        } else if (minutes == 1) {
            return "a minute ago";
        } else if (hours < 1) {
            return minutes + " minutes ago";
        } else if (hours == 1) {
            return "an hour ago";
        } else if (days < 1) {
            return hours + " hours ago";
        } else if (days == 1) {
            return "yesterday";
        } else {
            return days + " days ago";
        }
    }

}
