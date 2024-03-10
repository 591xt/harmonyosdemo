import { START_TIME } from '../common/constants/CommonConstants';

@Observed
export  class ViewPlayerController{
  public currentTime: number =0;
  public durationTime: number =0;
  public isPlay: boolean = false;
  public isOpacity: boolean = false;
  public durationStringTime: string = START_TIME;
  public currentStringTime: string = START_TIME;
  public flag: boolean = false;
  public isLoading: boolean =false;
  public progressVal: number = 0;
  public controller: VideoController = new VideoController();
}