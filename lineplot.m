function [fileinfo,xdata,ydata] = lineplot(filelist)
    global filepath;
    if ~iscell(filelist)
        filename=[filepath,'/',filelist];
        [headlines,fileinfo]=gethead(filename);
        [xdata,ydata]=getdata(filename,headlines);
    end
end

function [headlines,fileinfo]=gethead(filename)
    headlines=int64(0);
    fileinfo='';
    fid=fopen(filename);
    tline=fgets(fid);
    while (ischar(tline))
        if (tline(1)=='#')
            fileinfo = [fileinfo tline];
            headlines = headlines+1;
        else
            break;
        end
        tline=fgets(fid); 
    end
    fclose(fid);
end

function [xdata,ydata]=getdata(filename,headlines)
    global xcol ycol;
    opts = detectImportOptions(filename,'FileType', 'text');
    opts.DataLines = [headlines+1, Inf];
    opts.Delimiter = ["\t", ","," "];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts.ConsecutiveDelimitersRule = "join";
    
    data = readmatrix(filename,opts);
    xdata = data(:,xcol);
    ydata = data(:,ycol);
%     data = readtable(filename,opts);
%     xdata=table2array(data(:,xcol));
%     ydata=table2array(data(:,ycol));
end

