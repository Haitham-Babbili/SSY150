function [film,num_fram] = read_video(filename)
    video=VideoReader(filename);
    width = video.Width;
    height = video.Height;
    % create struct that contains video data
    film=struct('cdata',zeros(height,width,3,'uint8'),'colormap',[]);
    % read all frames into struct
    num_fram = 1;
    while hasFrame(video)
        film(num_fram).cdata = readFrame(video);
        num_fram = num_fram+1;
    end
end