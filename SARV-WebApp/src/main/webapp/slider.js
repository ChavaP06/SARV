/**
 * 
 */
const slider_conf = document.getElementById("conf-slider");
const value_Conf = document.getElementById("conf-value");

function sliderConf(){
    valPercent = (slider_conf.value / slider_conf.max)*100;
    slider_conf.style.background = `linear-gradient(to right, #3264fe ${valPercent}%, #d5d5d5 ${valPercent}%)`;
    value_Conf.textContent = slider_conf.value;
}
sliderConf();

const slider_Rules = document.getElementById("rules-slider");
const value_Rules = document.getElementById("rules-value");

function sliderRules(){
    valPercent = (slider_Rules.value / slider_Rules.max)*100;
    slider_Rules.style.background = `linear-gradient(to right, #3264fe ${valPercent}%, #d5d5d5 ${valPercent}%)`;
    value_Rules.textContent = slider_Rules.value;
}
sliderRules();