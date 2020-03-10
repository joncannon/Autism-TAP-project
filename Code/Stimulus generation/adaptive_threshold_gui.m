function adaptive_threshold_gui

f = figure('Visible', 'off', 'Position', [200, 500, 200, 200]);

hfreq = uicontrol('Style', 'text', 'String', 'Frequency', 'Position', [50, 140, 70, 25]);
hfreqedit = uicontrol('Style', 'edit', 'Position', [50, 120, 70, 25]);
hdB = uicontrol('Style', 'text', 'String', 'Relative dB', 'Position', [50, 90, 70, 25]);
hdBedit = uicontrol('Style', 'edit', 'Position', [50, 70, 70, 25]);
hplay = uicontrol('Style', 'pushbutton', 'String', 'Play', 'Position', [50, 30, 70, 25], 'Callback', @playbutton_Callback);

f.Name = 'Play a beep!'
f.Visible = 'on'

    function playbutton_Callback(source, eventdata)

        x_beep = 1:(.2 * 44100);
        n_samples = length(x_beep);
        freq = str2double(get(hfreqedit, 'String'));
        rel_dB = str2double(get(hdBedit, 'String'));
        
        amp = .1 * 10.^((rel_dB+10-50)/20);
        
        envlp = min(n_samples/2-abs((1:n_samples) - floor(n_samples/2)), .005*44100)./(.005*44100);

        beep = amp * sin(x_beep * 2*pi * freq / 44100).* envlp;
        sound(beep, 44100);
    end
end