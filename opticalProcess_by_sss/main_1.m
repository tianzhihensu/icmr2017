clc;
clear;

sourceDir = 'E:\研究生\研二下\ICPR\experiments\spit_frames\ch3_train_frames\';
postfix = '';
destiDir = '../../optical_flow_dat_file/';
getOpticalFlowBatch_1(sourceDir, postfix, destiDir);
