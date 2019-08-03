// The MIT License (MIT)
//
// Copyright (c) 2017 train-it.eu
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


var laser = {
    enabled: false,
    timer: setTimeout(this.off, 1),
    ptr: (function() {
        var ptr = document.createElement("div");
        ptr.id = "laser";
        document.body.appendChild(ptr);
        return ptr;
    })(),

    on : function() {
        if(this.enabled)
            $('#laser').show();
    },
    off : function() {
        $('#laser').hide();
    },
    switch : function() {
        this.enabled = !this.enabled;
        if(this.enabled) {
            this.on();
            $('*').css('cursor', 'none');
        }
        else {
            this.off();
            $('*').css('cursor', 'initial');
        }
    },
    move : function(x, y) {
        $('#laser').css('left', x - 5).css('top', y - 5);
        this.on();
        clearTimeout(this.timer);
        this.timer = setTimeout(this.off, 1000);
    },
    click : function(state) {
        $('#laser').css('box-shadow', (state ? '0px 0px 10px 5px rgb(51, 255, 119)' : '0px 0px 20px 5px rgb(51, 255, 119)'));
    }
};

$(document).ready(function() {
    $(document).mouseleave(function() {
        laser.off();
        return false;
    });
    $(document).mouseenter(function() {
        laser.on();
        return false;
    });
    $(document).mousemove(function(e) {
        laser.move(e.clientX, e.clientY);
    });
    $(document).mousedown(function() {
        laser.click(true);
        return true;
    });
    $(document).mouseup(function() {
        laser.click(false);
        return true;
    });
    $(document).keydown(function(e) {
        if(e.keyCode == 76) {
            laser.switch();
        }
    });
});
