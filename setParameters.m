function cfg = setParameters

    % Initialize the parameters and general configuration variables
    cfg = struct();

    % by default the data will be stored in an output folder created where the
    % setParamters.m file is
    % change that if you want the data to be saved somewhere else
    cfg.dir.output = fullfile( ...
        fileparts(mfilename('fullpath')), '..', ...
        'output');

    %% Debug mode settings

    cfg.debug.do = true; % To test the script out of the scanner, skip PTB sync
    cfg.debug.smallWin = false; % To test on a part of the screen, change to 1
    cfg.debug.transpWin = true; % To test with trasparent full size screen

    cfg.verbose = false;

    %% Engine parameters

    cfg.testingDevice = 'pc';
    cfg.eyeTracker.do = false;
    cfg.audio.do = true;

    cfg = setMonitor(cfg);

    % Keyboards
    cfg = setKeyboards(cfg);

    % MRI settings
    cfg = setMRI(cfg);

    %% Experiment Design

    cfg.design.names              = {'static', 'motion'};
    cfg.design.possibleDirections = [-1 1]; % 1 motion , -1 static %NOT IN USE AT THE MOMENT
    cfg.design.numBlocks          = size(cfg.design.names , 2); % TO CHECK
    cfg.design.nbRepetitions     = 1;  % AT THE MOMENT IT IS NOT SET IN THE MAIN SCRIPT
    cfg.design.nbEventsPerBlock   = 12;

    %% Timing

    % FOR 7T: if you want to create localizers on the fly, the following must be
    % multiples of the scanneryour sequence TR
    %
    % IBI
    % block length = (cfg.eventDuration + cfg.ISI) * cfg.design.nbEventsPerBlock

    % Time between blocs in secs
    cfg.timing.IBI = 1.8 * 3; % 8;
    % Time between events in secs
    cfg.timing.ISI = 0.1;
    % Number of seconds before the motion stimuli are presented
    cfg.timing.onsetDelay = .1;
    % Number of seconds after the end all the stimuli before ending the run
    cfg.timing.endDelay = .1;

    %% Auditory Stimulation

    cfg.audio.channels = 2;

    %% Task(s)

    cfg.task.name = 'auditory localizer';

    % Instruction
    cfg.task.instruction = '1-Detect the RED fixation cross\n \n\n';

    % Fixation cross (in pixels)
    cfg.fixation.type = 'cross';
    cfg.fixation.colorTarget = cfg.color.red;
    cfg.fixation.color = cfg.color.white;
    cfg.fixation.width = 1;
    cfg.fixation.lineWidthPix = 2;
    cfg.fixation.xDisplacement = 0;
    cfg.fixation.yDisplacement = 0;

    cfg.target.maxNbPerBlock = 2;
    cfg.target.duration = 0.05; % In secs

    cfg.extraColumns = {'direction', 'speed', 'target', 'event', 'block', 'keyName'};

end

function cfg = setMonitor(cfg)

    % Monitor parameters for PTB
    cfg.color.white = [255 255 255];
    cfg.color.black = [0 0 0];
    cfg.color.red = [255 0 0];
    cfg.color.grey = mean([cfg.color.black; cfg.color.white]);
    cfg.color.background = cfg.color.black;
    cfg.text.color = cfg.color.white;

    % Monitor parameters
    cfg.screen.monitorWidth = 50; % in cm
    cfg.screen.monitorDistance = 40; % distance from the screen in cm

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.screen.monitorWidth = 50;
        cfg.screen.monitorDistance = 40;
    end
end

function cfg = setKeyboards(cfg)
    cfg.keyboard.escapeKey = 'ESCAPE';
    cfg.keyboard.responseKey = {'space', 't'};
    cfg.keyboard.keyboard = [];
    cfg.keyboard.responseBox = [];

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.keyboard.keyboard = [];
        cfg.keyboard.responseBox = [];
    end
end

function cfg = setMRI(cfg)
    % letter sent by the trigger to sync stimulation and volume acquisition
    cfg.mri.triggerKey = 't';
    cfg.mri.triggerNb = 4;

    cfg.mri.repetitionTime = 1.8;

    cfg.bids.MRI.Instructions = 'Detect the RED fixation cross';
    cfg.bids.MRI.TaskDescription = [];

end
