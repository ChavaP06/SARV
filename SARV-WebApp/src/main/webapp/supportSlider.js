/**
 * 
 */
window.onload = function(){
    slideOne();
    slideTwo();
}

/* Support Slider */
let sliderOne = document.getElementById("support-slider-1");
let sliderTwo = document.getElementById("support-slider-2");
let displayValOne = document.getElementById("support-range1");
let displayValTwo = document.getElementById("support-range2");
let minGap = 0;
let sliderTrack = document.querySelector(".support-slider-track");
let sliderMaxValue = document.getElementById("support-slider-1").max;

/* Confidence */
let confSlider = document.getElementById("conf-slider");
let confValue = document.getElementById("conf-value");

function slideOne(){
    if(parseFloat(sliderTwo.value) - parseFloat(sliderOne.value) <= minGap){
        sliderOne.value = parseFloat(sliderTwo.value) - minGap;
    }
    displayValOne.textContent = sliderOne.value;
    fillColor();
}
function slideTwo(){
    if(parseFloat(sliderTwo.value) - parseFloat(sliderOne.value) <= minGap){
        sliderTwo.value = parseFloat(sliderOne.value) + minGap;
    }
    displayValTwo.textContent = sliderTwo.value;
    fillColor();
}
function fillColor(){
    percent1 = (sliderOne.value / sliderMaxValue) * 100;
    percent2 = (sliderTwo.value / sliderMaxValue) * 100;
    sliderTrack.style.background = `linear-gradient(to right, #dadae5 ${percent1}% , #3264fe ${percent1}% , #3264fe ${percent2}%, #dadae5 ${percent2}%)`;
}