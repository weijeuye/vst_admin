    //公共方法：校验敏感词（array：要校验的jquery对象数组，isAsync：是否为异步）
    function validateSensitiveWord(array, isAsync){
        var hasSensitive = false;

        for (var i=0; i<array.length; i++) {
            var obj = $(array[i]);
            //清除obj后的已有的 存在敏感词提示 标签
            obj.siblings(".has_senisitive").remove();

            if ($.trim(obj.val())!="") {
                //如果是日期类型，不校验
                if(obj.is(".Wdate")){
                    continue;
                }
                //如果是纯数字，不校验
                var number = /^[0-9]+$/;
                if(number.test($.trim(obj.val()))){
                    continue;
                }
                //如果是搜索框，则不显示
                if(obj.is(".searchInput")){
                    continue;
                }

                var reult = sendAjaxValidateSensitiveWord(obj, isAsync);
                if (reult) {
                    hasSensitive = true;
                }
            }
        }

        return hasSensitive;
    }

    //公共方法：发送ajax去校验敏感词（obj：要校验的jquery对象，isAsync：是否为异步）
    function sendAjaxValidateSensitiveWord(obj, isAsync) {
        //是否有敏感词变量
        var existSensitive = false;
        $.ajax({
            url : "/vst_admin/prod/product/sensitiveWord.do",
            type : "post",
            data : {word:obj.val()},
            async : isAsync,
            success : function(result) {
                if(result.message!=""){
                    existSensitive = true;
                    obj.after('<span class="has_senisitive" style="color:red">有敏感词:'+result.message+'</span>');
                }
            },
            error : function(){
                console.log("Call refreshSensitiveWord occurs error");
            }
        });

        return existSensitive;
    }