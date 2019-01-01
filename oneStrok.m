function [res,road]=oneStrok(startPointX,startPointY,table,points,count,coorX,coorY)

% check if stop
% left point
leftP = false;
rightP = false;
upP = false;
downP = false;

LeftInPts = false;
RightInPts = false;
UpInPts = false;
DownInPts = false;
[row,col] = size(points);
row = row - 1;
[trow,tcol] = size(table);
% points

if row >= 1
    for i = 1:row
        if points(i,1) == startPointX-1 && points(i,2) == startPointY
            LeftInPts = true;
        elseif points(i,1) == startPointX+1 && points(i,2) == startPointY
            RightInPts = true;
        elseif points(i,1) == startPointX && points(i,2) == startPointY-1
            UpInPts = true;
        elseif points(i,1) == startPointX && points(i,2) == startPointY+1
            DownInPts = true;
        end
    end
%         cmd = ['C:\Changzhi\dnplayer2/adb.exe shell input tap ',num2str(coorX(points(end,2),points(end,1))),' ',num2str(coorY(points(end,2),points(end,1)))];
%     system(cmd);
%     pause(0.5)
else
    %   cmd = ['C:\Changzhi\dnplayer2/adb.exe shell input tap ',num2str(coorX(startPointX,startPointY)),' ',num2str(coorY(startPointX,startPointY))];
    % system(cmd);
    % pause(0.5)
end

if startPointX == 1
    leftP = true;
elseif startPointX == tcol
    rightP = true;
end
if startPointX > 1
    if table(startPointY,startPointX-1)==0 || LeftInPts
        leftP = true;
    end
end
if startPointX < tcol
    if table(startPointY,startPointX+1)==0 || RightInPts
        rightP = true;
    end
end

if startPointY == 1
    upP = true;
elseif startPointY == trow
    downP = true;
end
if startPointY > 1
    if table(startPointY-1,startPointX)==0 || UpInPts
        upP = true;
    end
end
if startPointY < trow
    if table(startPointY+1,startPointX)==0 || DownInPts
        downP = true;
    end
end

if leftP && rightP && upP && downP
    if row == count
        road = points(2:end,:);
        res = true;
        msg = 'found it'
%         for i=1:length(road)
%             cmd = ['C:\Changzhi\dnplayer2/adb.exe shell input tap ',num2str(coorX(road(i,1),road(i,2))),' ',num2str(coorY(road(i,1),road(i,2)))];
%             system(cmd);
%             pause(0.5)
%         end
        return;
    else
%         msg = 'No road!'
        res = false;
        road = [];
        %         result = points;
        % cmd = ['C:\Changzhi\dnplayer2/adb.exe shell input tap ',num2str(coorX(points(end-1,1),points(end-1,2))),' ',num2str(coorY(points(end-1,1),points(end-1,2)))];
        % system(cmd);
        % pause(0.5)
        return;
    end
end

% Up
if startPointY > 1
    if table(startPointY-1,startPointX)==1 && ~UpInPts
        [t1,road] = oneStrok(startPointX,startPointY-1,table,[points;startPointX,startPointY-1;],count,coorX,coorY);
        if t1
            res = true;
            return;
        end
        'UP';
    end
end
% Down
if startPointY < trow
    if table(startPointY+1,startPointX)==1 && ~DownInPts
        [t1,road] = oneStrok(startPointX,startPointY+1,table,[points;startPointX,startPointY+1;],count,coorX,coorY);
        if t1
            res = true;
            return;
        end
        'Down';
    end
end
% Left
if startPointX > 1
    if table(startPointY,startPointX-1)==1 && ~LeftInPts
        [t1,road] = oneStrok(startPointX-1,startPointY,table,[points;startPointX-1,startPointY;],count,coorX,coorY);
        if t1
            res = true;
            return;
        end
        'Left';
    end
end
% Right
if startPointX < tcol
    if table(startPointY,startPointX+1)==1 && ~RightInPts
        [t1,road] = oneStrok(startPointX+1,startPointY,table,[points;startPointX+1,startPointY;],count,coorX,coorY);
        if t1
            res = true;
            return;
        end
        'Right';
    end
end

road = [];
res = false;
end