$files = Get-ChildItem "C:\Users\Falak\Documents\PDFgear\202603j" -Recurse -Include "testlunch.html","testdinner.html"
foreach ($file in $files) {
    Write-Host "`nProcessing: $($file.Name)" -ForegroundColor Cyan
    
    # 读取文件内容
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # 1. 修改单号 - 使用更灵活的正则
    # 先查找包含"單"或"单"的 5-7 位数字
    $pattern = '(?<=單 [號]?|单 [号]？)[\s:：]*(\d{4,7})'
    $matchNum = [regex]::Match($content, $pattern)
    
    if ($matchNum.Success) {
        $originalNum = [int]$matchNum.Groups[1].Value
        $randomNum = Get-Random -Minimum 50 -Maximum 130
        $newNum = $originalNum + $randomNum
        # 直接替换找到的整个匹配
        $content = $content.Remove($matchNum.Index, $matchNum.Length).Insert($matchNum.Index, $newNum)
        Write-Host "Modified: $originalNum + $randomNum = $newNum" -ForegroundColor Green
    } else {
        # 备用方案：直接找 5-7 位数字（假设第一个出现的就是单号）
        Write-Host "Trying fallback pattern..." -ForegroundColor Yellow
        $fallbackPattern = '\b(\d{5,7})\b'
        $fallbackMatch = [regex]::Match($content, $fallbackPattern)
        if ($fallbackMatch.Success) {
            $originalNum = [int]$fallbackMatch.Groups[1].Value
            $randomNum = Get-Random -Minimum 50 -Maximum 130
            $newNum = $originalNum + $randomNum
            $content = [regex]::Replace($content, $fallbackPattern, { 
                param($m) 
                return ($originalNum + $randomNum).ToString() 
            }, [System.Text.RegularExpressions.RegexOptions]::None, 1)
            Write-Host "Fallback - Modified: $originalNum + $randomNum = $newNum" -ForegroundColor Green
        } else {
            Write-Host "Single number not found" -ForegroundColor Red
        }
    }
    
    
    # 3. 处理时间：加上 1-30 分钟的随机数
    $timeMatch = [regex]::Match($content, '\d{2}/\d{2}/\d{4}\s+\d{2}:\d{2}')
    if ($timeMatch.Success) {
        $timeStr = $timeMatch.Value
        Write-Host "Found time: '$timeStr'" -ForegroundColor Yellow
        
        try {
            # 解析时间（去掉多余空格）
            $cleanTimeStr = $timeStr -replace '\s+', ' '
            $dateTime = [datetime]::ParseExact($cleanTimeStr, "dd/MM/yyyy HH:mm", $null)
            # 生成随机分钟数 (1-30)
            $randomMinutes = Get-Random -Minimum 20 -Maximum 51
            # 加上随机分钟
            $newDateTime = $dateTime.AddMinutes($randomMinutes)
            
            # 手动格式化，保持斜杠和 3 个空格
            $newDay = $newDateTime.Day.ToString("00")
            $newMonth = $newDateTime.Month.ToString("00")
            $newYear = $newDateTime.Year
            $newHour = $newDateTime.Hour.ToString("00")
            $newMinute = $newDateTime.Minute.ToString("00")
            $newTimeStr = "$newDay/$newMonth/$newYear   ${newHour}:${newMinute}"
            
            # 替换时间
            $content = $content -replace '\d{2}/\d{2}/\d{4}\s+\d{2}:\d{2}', $newTimeStr
            Write-Host "Time: $timeStr + ${randomMinutes}min = $newTimeStr" -ForegroundColor Cyan
        }
        catch {
            Write-Host "Time parse failed: $timeStr - Error: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Time: NOT FOUND" -ForegroundColor Red
    }
    
    # 保存
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
}
Write-Host "`nALL DONE!" -ForegroundColor Yellow
