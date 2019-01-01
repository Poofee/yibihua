% 2018-12-28
% by Poofee
% yibihua
for iter=1:15
%     clear all
    % adb shell input tap X Y
    % adb shell input swipe X1 Y1 X2 Y2
    system('C:\Changzhi\dnplayer2/adb.exe shell screencap -p /sdcard/screencap.png');
    system('C:\Changzhi\dnplayer2/adb.exe pull  /sdcard/screencap.png');
%     system('C:\Changzhi\dnplayer2/adb.exe shell input tap 440 858');
    
    rectwidth = 120;
    rectgap = 10;
    cornerX = 85;%60;
    cornerY = 290;%340;%410;
    coorX = zeros(7,6);
    coorY = zeros(7,6);
    
    % read the screenshot and rotate 90
    img = imread('screencap.png');
    img90 = img;%imrotate(img,-90);
    I2=double(im2bw(img90,90/255));
    % imshow(img90);
    % initial the position
    offset = 20;
    
    row = 7;
    col = 6;
    imgsize = size(img90);
    %read the img and check the left bound
    I3=double(im2bw(img90,230/255));
    up1 = 500; up2 = 1200; rwidth = 2;cornerX=1;
    meanRGB = mean(img90(up1:up2,cornerX:(cornerX+rwidth),3),'all');
    while meanRGB > 248
        cornerX = cornerX + 1;
        meanRGB = mean(img90(up1:up2,cornerX:(cornerX+rwidth),3),'all');
    end
    cornerX = cornerX + rwidth;
    % calc right bound
    rightBound = imgsize(2);
    meanRGB = mean(img90(up1:up2,(rightBound-rwidth):(rightBound),3),'all');
    for i=imgsize(2):-1:1
        rightBound = rightBound - 1;
        meanRGB = mean(img90(up1:up2,(rightBound-rwidth):(rightBound),3),'all');
        if meanRGB < 248
            break;
        end
    end
    rightBound = rightBound - rwidth;
    % calc the down bound
    left1=200;left2=700;downBound=1400;
    for i=imgsize(1):-1:1
        meanRGB = mean(img90((downBound-rwidth):downBound,left1:(left2),3),'all');
        if meanRGB < 248
            break;
        end
        downBound = downBound - 1;
    end
    downBound = downBound - rwidth;
    
    % calc the length of each rect
    left1=cornerX - 20; left2=left1+50;twidth=2;up1=downBound-70;
    findw = false;rectwidth=0;
    for i=1:imgsize(2)-left1
        meanRGB = mean(I3((up1-2):(up1),(left1+i):(left1+i+1)),'all');
        if meanRGB < 0.1
            findw = true;
            %        break;
        end
        if findw
            rectwidth = rectwidth + 1;
            if meanRGB > 0.5
                
                break;
            end
        end
    end
    rectwidth = rectwidth - 1;
    if rectwidth > 180 || rectwidth < 50
        
    
    
    left1=cornerX - 20; left2=left1+50;twidth=2;up1=downBound-240;
    findw = false;rectwidth=0;
    for i=1:imgsize(2)-left1
        meanRGB = mean(I3((up1-2):(up1),(left1+i):(left1+i+2)),'all');
        if meanRGB < 0.1
            findw = true;
            %        break;
        end
        if findw
            rectwidth = rectwidth + 1;
            if meanRGB > 0.5
                
                break;
            end
        end
    end
    end
    rectwidth = rectwidth - 1;
    % calc the up bound
    left1=cornerX+20;left2=rightBound-20;upBound=320;
    for i=1:imgsize(1)-rwidth
        %meanRGB = mean(I3((upBound):(upBound+rwidth),left1:(left2)),'all')
        upsize = size(find(I3((upBound):(upBound+rwidth),left1:(left2))==0));
        if upsize(1) > rwidth*rectwidth
            break;
        end
        upBound = upBound + 1;
    end
    upBound = upBound + rwidth;
    cornerY = upBound;
    
    tablewidth = rightBound - cornerX;
    tableheight = downBound - upBound;
    [tablewidth,tableheight]
    row = floor(tableheight/rectwidth);
    col = floor(tablewidth/rectwidth);
    [row,col]
    table = zeros(row,col);
    %
    for i = 1:row
        for j = 1:col
            coorX(i,j) = cornerX + (j-1/2)*rectwidth + (j-1)*rectgap;
            coorY(i,j) = cornerY + (i-1/2)*rectwidth + (i-1)*rectgap;
%             cmd = ['C:\Changzhi\dnplayer2/adb.exe shell input tap ',num2str(coorX(i,j)),' ',num2str(coorY(i,j))];
%             system(cmd);
%             pause(0.5);
        end
    end
    
%     for i=1:imgsize(1)
%         meanRGB = mean(img90(i,1:imgsize(2),3),'all');
%         plot(i,meanRGB,'*');hold on
%     end
    offset = 5;
    size0 = zeros(row,col);
    for i = 1:row
        for j=1:col
            minX = cornerX + offset + (j-1)*(rectwidth+rectgap);
            maxX = cornerX+j*rectwidth + (j-1)*rectgap-offset;
            minY = cornerY + offset + (i-1)*(rectwidth+rectgap);
            maxY = cornerY+i*rectwidth + (i-1)*rectgap-offset;
            b = img90(minY:maxY,minX:maxX,3)/3+img90(minY:maxY,minX:maxX,2)/3+img90(minY:maxY,minX:maxX,1)/3;
%             b = b / 3;
            %bstart = min(I2(minY:maxY,minX:maxX),[],'all');
            bstart = size(find(I2(minY:maxY,minX:maxX)==0));
            size0(i,j) = bstart(1);
            meanRGB = mean(b,'all');
%             a = img90(minY:maxY,minX:maxX,3);
            amin = min(b,[],'all');
            amax = max(b,[],'all');
%             s = std(img90(minY:maxY,minX:maxX,3),0,'all');
            if meanRGB > 240
                %            no road
                table(i,j) = 0;
            else
                table(i,j) = 1;
            end
        end
    end
    maxstart = max(size0,[],'all');
    [row0,col0] = find(size0==maxstart);
    table(row0,col0) = -1;
    count = length(find(table==1));
    % tmp = find(table==-1);
    
    for i=1:row
        for j=1:col
            if table(i,j) == -1
                startPointX = j;
                startPointY = i;
                break;
            end
        end
    end
    points = [startPointX,startPointY;];
    road = [];
    [res,road] = oneStrok(startPointX,startPointY,table,points,count,coorX,coorY);
    % call the solve function
    for i=1:length(road)
        cmd = ['C:\Changzhi\dnplayer2/adb.exe shell input tap ',num2str(coorX(road(i,2),road(i,1))),' ',num2str(coorY(road(i,2),road(i,1)))];
        system(cmd);
        pause(0.2)
    end
    pause(2)
    cmd = ['C:\Changzhi\dnplayer2/adb.exe shell input tap 465 865'];
    system(cmd);
    pause(1)
end