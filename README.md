# Jasper for Experimental Platform

Jasper is an open source platform for developing always-on, voice-controlled applications.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=UzaqNF6NlBA
" target="_blank"><img src="http://img.youtube.com/vi/UzaqNF6NlBA/0.jpg" 
alt="Jasper Video" width="240" height="180"></a>

## Requirements

* A machine that runs [Experimental Platform](https://github.com/experimental-platform/platform-configure-script)
* A USB microphone, we used [this](http://www.amazon.com/Adjustable-Microphone-Compatible-Chatting-Recording/dp/B00UZY2YQE/)
* A speaker, we used [this](http://www.amazon.com/Logitech-S150-Speakers-Digital-Sound/dp/B000ZH98LU)

## Installation

Make sure the microphone and speakers are plugged in before you deploy the code.

    git clone https://github.com/experimental-platform/example-dockerfile-jasper.git
    cd example-dockerfile-jasper
    git remote add platform ssh://dokku@your-box.local:8022/example-dockerfile-jasper
    git push platform master
