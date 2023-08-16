-- 1 ZADANIE
DECLARE @CTime TIME = GETDATE()
IF @CTime >= '06:00:00' AND @CTime <= '12:00:00'
PRINT 'ДОБРОЕ УТРО!'
ELSE IF @CTime >= '12:00:00' AND @CTime <='18:00:00'
PRINT 'ДОБРЫЙ ДЕНЬ!'
ELSE 
PRINT 'ДОБРЫЙ ВЕЧЕР!'

-- 2 ZADANIE
DECLARE @Bykvi VARCHAR(100) = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
DECLARE @Length INT = 10
DECLARE @Pass NVARCHAR(10) = ''

WHILE LEN(@Pass)<@Length
BEGIN
SET @Pass = @Pass + SUBSTRING(@Bykvi,CAST(RAND()*LEN(@Bykvi)+1 AS INT),1)
END
PRINT @Pass

-- 3 ZADANIE
DECLARE @Num1 INT = 1
DECLARE @Num2 INT = 1

WHILE @Num1 <=25
BEGIN
SET @Num2 = @Num2 * @Num1
PRINT 'Факториал ' + CONVERT(NVARCHAR,@Num1) + ' = ' + CONVERT(NVARCHAR,@Num2)
SET @Num1 = @Num1 + 1
END

-- 4 ZADANIE
DECLARE @UpperLimit INT = 1000000
DECLARE @Numbers TABLE (Number INT PRIMARY KEY)
DECLARE @Counter INT = 2

WHILE @Counter <= @UpperLimit
BEGIN
    INSERT INTO @Numbers (Number) VALUES (@Counter)
    SET @Counter = @Counter + 1
END

DECLARE @Current INT = 2
WHILE @Current * @Current <= @UpperLimit
BEGIN
    IF EXISTS (SELECT 1 FROM @Numbers WHERE Number = @Current)
    BEGIN
        DECLARE @Multiplier INT = @Current * @Current
        WHILE @Multiplier <= @UpperLimit
        BEGIN
            DELETE FROM @Numbers WHERE Number = @Multiplier
            SET @Multiplier = @Multiplier + @Current
        END
    END
    
    SET @Current = @Current + 1
END
SELECT Number FROM @Numbers

-- 5 ZADANIE
DECLARE @Capital INT = 500
DECLARE @Bet INT = 10
DECLARE @Prize INT = 50

WHILE @Capital >= @Bet
BEGIN
    PRINT 'Текущий баланс: ' + CAST(@Capital AS VARCHAR(10)) + ' кредитов. Нажмите F5 для продолжения...';
    EXEC sp_executesql N'WAITFOR DELAY ''00:00:02'';'

    SET @Capital = @Capital - @Bet
    
    DECLARE @Number1 INT = CAST(RAND() * 7 AS INT)
    DECLARE @Number2 INT = CAST(RAND() * 7 AS INT)
    DECLARE @Number3 INT = CAST(RAND() * 7 AS INT)
    
    PRINT 'Выпавшие числа: ' + CAST(@Number1 AS VARCHAR(1)) + ', ' + CAST(@Number2 AS VARCHAR(1)) + ', ' + CAST(@Number3 AS VARCHAR(1))

    IF @Number1 = @Number2 AND @Number2 = @Number3
    BEGIN
        SET @Capital = @Capital + @Prize
        PRINT 'Поздравляем! Вы выиграли ' + CAST(@Prize AS VARCHAR(10)) + ' кредитов. Ваш текущий баланс: ' + CAST(@Capital AS VARCHAR(10)) + ' кредитов.'
    END
    ELSE IF @Number1 = 7 AND @Number2 = 7 AND @Number3 = 7
    BEGIN
        SET @Capital = @Capital + 777
        PRINT 'Джекпот! Вы выиграли 777 кредитов. Ваш текущий баланс: ' + CAST(@Capital AS VARCHAR(10)) + ' кредитов.'
    END
    ELSE
    BEGIN
        PRINT 'Увы, не повезло. Ваш текущий баланс: ' + CAST(@Capital AS VARCHAR(10)) + ' кредитов.'
    END;
    
    EXEC sp_executesql N'WAITFOR DELAY ''00:00:02'';'
END;

IF @Capital <= 0
    PRINT 'Игра завершена. Ваш баланс исчерпан.'
ELSE
    PRINT 'Поздравляем! Вы выиграли! Ваш баланс: ' + CAST(@Capital AS VARCHAR(10)) + ' кредитов.'
