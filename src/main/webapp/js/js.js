// JavaScript Document
$(document).ready(function(){
	//文档就绪自动渲染日历层
	pandora.calendar({
		target:"#divContainer",//日历容器. 使用jquery选择器语法
		selectDateCallback:selectDateCallBack,
		cancelDateCallback: cancelDateCallBack,
		completeCallback: reRendarSelectedDate,
		autoRender:true,
		allowMutiSelected: true,
        isTodayClick: true,
        mos: 24,
        template: "small"
 	}); 
	
	$("#btnDel").bind("click",function(){removeDate();});
});

function removeDate(){
    var target = $("#selDate option:selected");
    $.each(target, function (index, items) {
        var value = $(items).val();
        if (!value)
            return true;
        var next = $(items).next().val() ? $(items).next() : $(items).prev();//判断下一个被选中的目标
        $("#selDate option:selected").remove();
        next.attr("selected", "selected");
        $("td.calSelected[date-map='" + value + "']").removeClass("calSelected");
    });
}

function selectDateCallBack(data){
	var date=data.selectedDate;
	if(!date)
		return;
	if($("#selDate option[value='"+date+"']").length!=0)//once allowed
		return;
	$("#selDate").append("<option value='"+date+"'>"+date+"</option>");
}

function cancelDateCallBack(data){
    var date=data.selectedDate;
    if(!date)
        return;
    $("#selDate option[value='"+date+"']").remove();
}

function reRendarSelectedDate() {
    var target = $("#selDate option");
    $.each(target, function (index, items) {
        var value = $(items).val();
        if (!value)
            return true;
        $("td[date-map='" + value + "']").addClass("calSelected");
    });
}
