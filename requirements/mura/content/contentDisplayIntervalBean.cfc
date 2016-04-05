component extends="mura.bean.bean" {

    property name="every" datatype="integer" default="1";
    property name="repeats" datatype="integer" default="1";
    property name="allDay" datatype="integer" default="0";
    property name="end" datatype="string" default="";
    property name="endOn" datatype="date";
    property name="endAfter" datatype="integer" default="0";
    property name="daysofweek" datatype="string" default="";
    property name="detectConflicts" datatype="integer" default="0";
    property name="detectSpan" datatype="integer" default="12";
    property name="timezone" datatype="string";

    function init(){
            super.init(argumentCollection=arguments);
            set('timezone',CreateObject("java", "java.util.TimeZone").getDefault().getID());
            return this;
    }

    function setContent(content){
        variables.content=arguments.content;
        return this;
    }

    function save(){
        variables.content.setDisplayInterval(this);
        return this;
    }
    
    function repeats(repeats){
        set('repeats',arguments.repeats);
        return repeats;
    }

    function every(every){
        set('every',arguments.every);
        return this;
    }

    function allDay(allDay){
        set('allDay',arguments.allDay);
        return this;
    }

    function endOn(endOn){
        set('end','on');
        set('endOn',arguments.endOn);
        return this;
    }

    function endAfter(endAfter){
        set('end','after');
        set('endafter',arguments.endAfter);
        return this;

    }

    function daysofweek(daysofweek){
        set('daysofweek',arguments.daysofweek);
        return this;
    }

    function detectConflicts(detectConflicts){
        set('detectConflicts',arguments.detectConflicts);
        return this;
    }

    function detectSpan(detectSpan){
        set('detectSpan',arguments.detectSpan);
        return this;
    }

    function timezone(timezone){
        set('timezone',arguments.timezone);
        return this;
    }

}
