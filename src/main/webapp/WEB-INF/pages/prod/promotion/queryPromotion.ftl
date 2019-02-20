<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>活动查询页</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/active.css"/>
  
    
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/v5/modules/paging.css"/>

</head>
<body class="active">
    <div class="active_wrap">
        <form class="form-group" id="searchForm" action="/vst_admin/prod/promotion/desc/query.do" method="post">
            <div class="activeFilter">
                    <div class="row clearfix">
                        <div class="col w150">
                            <label>
                                <span class="w50 inline-block">活动ID：</span>
                                <input class="form-control w85" name="descId" type="text">
                            </label>
                        </div>
                        <div class="col w185">
                            <label>
                                <span class="w65 inline-block">活动名称：</span>
                                <input class="form-control w105" name="descName" type="text">
                            </label>
                        </div>
                        <div class="col w180">
                            <label>
                                <span class="w60 inline-block">产品ID：</span>
                                <input class="form-control w105" name="productId" type="text">
                            </label>
                        </div>
                        <div class="col w185">
                            <label>
                                <span class="w60 inline-block">创建人：</span>
                                <div class="form-group inline-block">
                                    <input name="Founder" id="Founder" type="text"
                                           class="form-control search w110 JS_autocomplete_f"
                                           data-validate="{required:true}" />
                                    <input type="hidden" class="JS_autocomplete_f_hidden" id="FounderId"
                                           name="userId"/>
                                    <!--<input type="hidden" class="JS_autocomplete_f_hidden_email" id="FounderEmail"-->
                                           <!--name="FounderEmail"/>-->
                                </div>
                            </label>
                        </div>
                        <div class="col w160">
                            <label>
                                <span class="w70 inline-block">是否有效：</span>
                                <select class="form-control w85" name="cancelFlag">
                                    <option value = "">全部</option>
                                    <option value = "Y">有效</option>
                                    <option value = "N">无效</option>
                                </select>
                            </label>
                        </div>
                        <div class="col w465">
                            <label>
                                <span class="w100 inline-block text-left">活动展示时间：</span>
                                <div class="active_calendar inline-block w350">
                                     <span class="form-group">
                                        <input name="descStartTime" type="text" placeholder="" class="form-control datetime w100" id="JS_date_start" onClick="WdatePicker()" readonly="readonly"/>
                                    </span>
                                    至
                                    <span class="form-group">
                                        <input name="descEndTime"  type="text" placeholder="" class="form-control datetime w100" id="JS_date_end"  onClick="WdatePicker({minDate:'#F{$dp.$D(\'JS_date_start\')}'})" readonly="readonly"/>
                                    </span>
                                </div>
                            </label>
                        </div>
                        <div class="col w225">
                            <label>
                                <span class="w100 inline-block text-center">所属BU：</span>
                                <select name="buCode" class="form-control w115">
                                    <option value="">全部</option>
                                    <#list buList as list>
		              				  <option value=${list.code!''} >${list.cnName!''}</option>
			       					</#list>
                                </select>
                            </label>
                        </div>
                        <div class="col w170">
                            <label>
                                <span class="w70 inline-block text-center">所属渠道：</span>
                                <select class="form-control w95" name="channelCode">
                                    <option value="">全部</option>
                                    <#list channelList as list>
		              				  <option value=${list.cnCode!''} >${list.cnName!''}</option>
			       					</#list>
                                </select>
                            </label>
                        </div>
                    </div>
            </div>
            <div class="active_btn w400">
                <span class="btn-group">
                    <a class="btn btn-primary JS_btn_select" id="search_button">查询</a>
                    <a class="btn btn-primary JS_add_baseInform" id="add_button">新增</a>
                </span>
            </div>
        </form>
        <div id="result" class="iframe_content mt20" ></div>
    </div>
	<div class="template">
        <div class="dialog-editBaseInformation">
            <iframe src="about:blank" class="iframe-editBaseInformation" frameborder="0"></iframe>
        </div>
    </div>
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/common.js"></script>
<!--<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/active.js"></script>-->
<script type="text/javascript" src="/vst_admin/js/promotion/active.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script src="http://s3.lvjs.com.cn/js/ui/lvmamaUI/lvmamaUI.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js"></script>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
<#include "/base/foot.ftl"/>
<script type="text/javascript">
    $(function(){
        //新添加日历 开始
	    $("#JS_date_start").each(function(){
	        $(this).ui("calendar",{
	            input : this,
	            parm:{dateFmt:'yyyy-MM-dd'}
	        })
	    })
	    //新添加日历 结束
    
        //设为有效
        $('.active_effect').click(function(){
            var html=$(this).html();
            if(html=='设为有效')
            {
                $(this).html('设为无效').parents('tr').find('span.text-danger').html('有效').attr('class','text-success');
                $(this).siblings('.JS_edit_baseInform').hide().siblings('.JS_check_baseInform').show();
            }
            else
            {
                $(this).html('设为有效').parents('tr').find('span.text-success').html('无效').attr('class','text-danger');
                $(this).siblings('.JS_check_baseInform').hide().siblings('.JS_edit_baseInform').show();
            }
        });

    })
    $(function(){
        //产品经理自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_autocomplete_f",
                "fillData": fillData,
                "choice": choice,
                "clearData": clearData
            });
            function fillData(self) {
            	var name = $("#Founder").val();
                var url = "/vst_admin/prod/promotion/desc/findMangement.do?name="+name;
                self.loading();
                $.ajax({
                    url: url,
                    success: function (json) {
                        var $ul = self.$menu.find("ul");
                        $ul.empty();
                        for (var i = 0; i < json.length; i++) {
                            var $li = $('<li  data-id="' + json[i].id + '">' + json[i].name + '</li>');
                            $ul.append($li)
                        }

                        self.loaded();
                    }
                });
            }

            function choice(self, $li) {

                var id = $li.attr("data-id");
                var $hidden = self.$input.parent().find(".JS_autocomplete_f_hidden");
//                var email = $li.attr("data-email");
//                var $email = self.$input.parent().find(".JS_autocomplete_pm_hidden_email");
                $hidden.val(id);

            }
            function clearData(self) {
                var $hidden = self.$input.parent().find(".JS_autocomplete_f_hidden");
                $hidden.val("");
//                var $email = self.$input.parent().find(".JS_autocomplete_pm_hidden_email");
//                $email.val("");
            }
        });
    })
    
    $(function(){
    	//查询
		$("#search_button").bind("click",function(){
			//加载
			loadPromotionList();
		});
	
		//加载
		function loadPromotionList(){
				
				$("#result").empty();
				$("#result").append("<div class='loading mt20' style='width:220px;margin:0px auto'><img src='../../../img/loading.gif' width='32' height='32' alt='加载中'>正在努力的加载数据中......</div>");
				 //ajax加载结果
				var $form=$("#searchForm");
				 $("#result").load($form.attr("action"),$form.serialize(),function(){
				});
		}
		
		var $template = $(".template");
		//新增
		$(".JS_add_baseInform").click(function(){
	        var url = "/vst_admin/prod/promotion/desc/toAdd.do";
	        new xDialog(url,{},{title:"新增活动",iframe:true,width:1000,hight:730});
   		});
    })
</script>
</body>
</html>
