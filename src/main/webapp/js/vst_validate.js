/**
*扩展JQuery 的验证规则，自定义验证规则不能使用属性配置方式，而且方法名不能用重复
*@author mayonghua
*@date 2013-10-28
*/

/**
 * 验证固定电话
 */
jQuery.validator.addMethod("isTel", function(value, element) {
    var tel = /^\d{3,4}-?\d{7,9}$/;//电话号码格式010-12345678   
    return this.optional(element) || (tel.test(value));       
 }, "请正确填写您的电话号码");

/**
 * 验证传真
 */
jQuery.validator.addMethod("isFax", function(value, element) {
    var fax = /^\d{3,4}-?\d{7,9}$/;//电话号码格式010-12345678   
    return this.optional(element) || (fax.test(value));       
 }, "请正确填写您的传真号码");

/**
 * 验证传真（可以带分机号）
 */
jQuery.validator.addMethod("isFaxExt", function(value, element) {
	var fax = /^\d{3,4}-?\d{7,9}(-?\d{1,9})?$/;//电话号码格式010-12345678-2000  
	return this.optional(element) || (fax.test(value));       
}, "请正确填写您的传真号码");

/**
 * 验证数字
 */
jQuery.validator.addMethod("isNum", function(value, element) {
    var num = /^[1-9]{0}\d*(\.\d{1,2})?$/;
    return this.optional(element) || (num.test(value));       
 }, "只能填写数字");
/**
 * 验证特殊字符
 */
jQuery.validator.addMethod("isChar", function(value, element) {
    var chars =  /^([\u4e00-\u9fa5]|[a-zA-Z0-9])+$/;//验证特殊字符  
    return this.optional(element) || (chars.test(value));       
 }, "不可输入特殊字符");
/**
 * 验证正整数
 */
jQuery.validator.addMethod("isInteger", function(value, element) {
    var chars =  /^[1-9]\d*|0$/;//验证正整数  
    return this.optional(element) || (chars.test(value));       
 }, "只能填写整数");
/**
 * 验证多个URL
 */
jQuery.validator.addMethod("isMultipleUrl", function(value, element) {
    var regex =  /^(http|ftp|https):\/\/([a-zA-Z0-9]+(\.[a-zA-Z0-9]+){0,3})(:[0-9]{1,4})?(\/\w+)*(\/|(\.\w+)?)$/;
    var array = value.replace("；", ";").split(";");
    var length = array.length;
    for(var i = 0; i < length; i++){
        var url = $.trim(array[i]);
        result = regex.test(url);
        if (!result) {
            break;
        }
    }
    return this.optional(element) || result;
 }, "URL不合法");



function getLowGoodsMargin(url,data){
    var data ;
    $.ajax({
       url : url,
       async: false,
       data : data,
       dataType:'JSON',
       type: "POST",
       success : function(result){
           data =  result;
       }
    });
    return data;
};
//为输入框添加class="validateIntger" 则只能输入整数
 $(document).delegate(".validateIntger","blur",function(e){
 var event = e || window.event,
 o = (event.srcElement || event.target);
 if (typeof(o.tagName) != "undefined") {
	value = $(o).val() + "";
	 if((/^(\+|-)?\d+$/.test(value)) && value>=-1)
    {
       return true;
    }
	 else if(value=="")
    {
	$(".validateIntgerWarn").css("display","none");
	 return true;
    }
	 else
	 {
	 $(o).val(""); 
	 $(".validateIntgerWarn").text("只能输入整数");
	 $(".validateIntgerWarn").css("display","inline-block");
	 }
  }
});
 $(document).delegate(".validateIntger2","blur",function(e){
	 var event = e || window.event,
	 o = (event.srcElement || event.target);
	 if (typeof(o.tagName) != "undefined") {
		value = $(o).val() + "";
		 if((/^(\+|-)?\d+$/.test(value)) && value>0)
		    {
		       return true;
		    }
		 else
		    {
			 $(o).val("");
		    }
	  }
	});
 
 function checkQuote(str) {
	 var items = new Array("/", "<", ">", "%", "#", "*", "&", "^", "~", "@", "!");
	 	 items.push( "'", "|", "\\","<<", ">>", "||", "//");
	 str = str.toLowerCase();
	 for (var i = 0; i < items.length; i++) {
	     if (str.indexOf(items[i]) >= 0) {
				return false;
	     }
	 }
	 return true;
}
function validateQuote()
{
  var freebieNameValue = $("#freebieName").val();
  var freebieDescValue = $("#freebieDesc").val();
  var useNoticeValue =  $("#useNotice").val();
  if(freebieNameValue!="")
  {
	var checkResult = checkQuote(freebieNameValue);
	if(checkResult==false)
	{
	  alert("赠品名称中不能含有<>%#*&^~@!~/\'||特殊字符!");
	  return false;
	}
  }
  if(freebieDescValue!="")
  {
	  var checkResult = checkQuote(freebieDescValue);
		if(checkResult==false)
		{
		  alert("赠品描述中不能含有<>%#*&^~@!~/\'||特殊字符!");
		  return false;
		}
  }
  if(useNoticeValue!="")
  {
	  var checkResult = checkQuote(useNoticeValue);
		if(checkResult==false)
		{
		  alert("赠品须知中不能含有<>%#*&^~@!~/\'||特殊字符!");
		  return false;
		}
  }
  return true;
};

function validateData()
{
  var freebieNameValue = $("#freebieName").val();
  var freebieDescValue = $("#freebieDesc").val();
  var useNoticeValue =  $("#useNotice").val();
  var expStartDateValue = $("#expStartDate").val();
  var expEndDateValue = $("#expEndDate").val();
  var d1 = new Date(expStartDateValue.replace(/\-/g, "\/"));  
  var d2 = new Date(expEndDateValue.replace(/\-/g, "\/"));  
  var stockNum = $("#stockNum").val();
  if(freebieNameValue=="")
  {
	$("#freebieNameWarn").removeClass("hidden");
    $("#freebieNameWarn").addClass("show");
    return false;
  }
  else if(freebieDescValue=="")
  {
	$("#freebieDescWarn").removeClass("hidden");
    $("#freebieDescWarn").addClass("show");
    return false;
  }
  else if(useNoticeValue=="")
  {
	 $("#useNoticeWarn").removeClass("hidden");
    $("#useNoticeWarn").addClass("show");
    return false;
  }
  else if(expStartDateValue=="" || expEndDateValue=="")
  {
    $("#expStartDateWarn").addClass("show");
    $("#DataWarn").addClass("hidden");
    return false;
  }
  else if(expStartDateValue !="" && expEndDateValue!= "" && d1 > d2)
  {
	$("#expStartDateWarn").addClass("hidden");
    $("#DataWarn").addClass("show");
    return false;
  }
  else if(stockNum=="" || stockNum==0)
  {
	  $("#consume").val("");
	  return true;
  }
  else if(stockNum!="" || stockNum!=0)
  {
	  var consume = $("#consume").val();
	  if(consume=="")
	  {
		  $("#consumeWarn").removeClass("hidden");
		  $("#consumeWarn").addClass("show");
	      return false;
	  }
	  else
		  {
		  return true;
		  }
  }
  else
  {
  return true;
  }
};