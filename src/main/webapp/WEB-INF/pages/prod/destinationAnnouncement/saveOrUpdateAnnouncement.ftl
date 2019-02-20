<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>新增公告页面</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/pandora-calendar.css"/>
    <link href="http://pic.lvmama.com/styles/backstage/v1/vst/base.css" rel="stylesheet">
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/common.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/activity-management/active.css"/>
</head>
<body class="active">
<div class="baseInformation" style="height:700px">
    <form>
        <dl class="clearfix">

            <dt>
                <label for="descId">
                    <span class="text-danger">*</span> 公告ID：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="id" id="announcementId"  <#if announcement!=null>value="${announcement.id!''}"</#if>  type="text" class="form-control w200" readonly="readonly"/>
                </div>
            </dd>
            <dt>
                <label for="descName">
                    <span class="text-danger">*</span> 公告名称：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="announcementName" id="announcementName" <#if announcement!=null>value="${announcement.announcementName!''}"</#if> type="text" class="form-control w200" data-validate-regular="^\d*$" data-validate="{required:true}" maxlength="20"/>
                </div>

            </dd>
            <dt>
                <label for="activeName">
                    <span class="text-danger">*</span> 起始时间：
                </label>
            </dt>
            <dd>
                <div class="active_calendar inline-block w500">
                         <span class="form-group">
                            <input name="startDate" type="text" placeholder="" <#if announcement!=null>value="${announcement.startDate!?string('yyyy-MM-dd')}"</#if> class="form-control datetime w100" id="JS_date_start" onClick="WdatePicker({maxDate:'#F{$dp.$D(\'JS_date_end\')}'})" readonly="readonly"/>
                         </span>
                    至
                        <span class="form-group">
                            <input name="endDate"  type="text" placeholder="" <#if announcement!=null>value="${announcement.endDate!?string('yyyy-MM-dd')}"</#if> class="form-control datetime w100" id="JS_date_end"  onClick="WdatePicker({minDate:'#F{$dp.$D(\'JS_date_start\')}'})" readonly="readonly"/>
                        </span>
                </div>
            </dd>
            <dt>
                <label for="activeName">
                    <span class="text-danger">*</span>显示渠道：
                </label>
            </dt>
            <dd>
                <div class="form-group">
                <#list channelList as list>
                    <div class="col w95">
                        <label>
                            <input name="channelCode" type="checkbox" class="JS_control_type" value="${list.cnCode!''}" data-validate="{required:true}"/>
                        ${list.cnName!''}
                        </label>
                    </div>
                </#list>
                    <input type="hidden" name="channelList" id="channelList" <#if announcement!=null>value="${announcement.channelList!''}"</#if>>
                </div>
            </dd>
            <dt>
                <label for="seq">
                    <span class="text-danger">*</span>公告排序：
                </label>
            </dt>
            <dd class="form-group">
                <select class="form-control w115 JS_activeSort"  name="rank" data-validate="{required:true}">
                    <option value="">请选择</option>
                    <option value="1" <#if announcement!=null && 1 == announcement.rank>selected</#if>>1</option>
                    <option value="2" <#if announcement!=null && 2 == announcement.rank>selected</#if>>2</option>
                    <option value="3" <#if announcement!=null && 3 == announcement.rank>selected</#if>>3</option>
                    <option value="4" <#if announcement!=null && 4 == announcement.rank>selected</#if>>4</option>
                    <option value="5" <#if announcement!=null && 5 == announcement.rank>selected</#if>>5</option>
                </select>
            </dd>
            <dt>
                <label for="descDescription">
                    公告内容：
                </label>
            </dt>
            <dd>
                <textarea name="content" id="content" class="active_textarea form-control" maxlength="500"><#if announcement!=null>${announcement.content}</#if></textarea>
            </dd>
        </dl>
        <div class="btn-group text-center">
            <a class="btn btn-primary JS_btn_save">保存</a>
            <a class="btn btn-primary JS_btn_bound"  target="_parent">绑定产品</a>

        </div>
    </form>
</div>

<!--页面结束-->
<!--脚本模板开始-->
<#--<div class="template">
    <!--保存成功&ndash;&gt;
    <div class="dialog-saveSuccess">
        <iframe src="about:blank" class="iframe-saveSuccess" frameborder="0"></iframe>
    </div>
    <!--基本信息&ndash;&gt;
    <div class="dialog-addBaseInformation">
        <iframe src="about:blank" class="iframe-addBaseInformation" frameborder="0"></iframe>
    </div>
</div>-->
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/pandora-calendar.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/vst/activity-management/active.js"></script>
<script src="http://s3.lvjs.com.cn/js/ui/lvmamaUI/lvmamaUI.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js"></script>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
<#include "/base/foot.ftl"/>
<script>
    var $document = $(document);
	var basePath="";
    //TODO 开发维护
    $(function () {
    	if($("#announcementId").val()!=''){
            var channelCode = $("#channelList").val();
            if(channelCode!=''){
                var $checkbox = $("input[type='checkbox']");
                for(var i in $checkbox){
                    if(channelCode.indexOf($checkbox[i].value) != -1){
                        $checkbox[i].checked="checked";
                    }
                }
            }
        }
        var parent = window.parent;
        var $document = $(document);
        var $form = $(".baseInformation").find("form");
        var validateAdd = backstage.validate({
            $area: $form,
            REQUIRED: "不能为空",
            showError: true
        });
        $document.on("click", ".JS_btn_save", function () {
            validateAdd.refresh();
            validateAdd.watch();
            validateAdd.test();
            if($("#JS_date_start").val()==""||$("#JS_date_end").val()==""){
            	if($("#JS_date_end").parent('.form-group').find('i[class="error"]').size()==0){
            		$("#JS_date_end").after('&nbsp;<i class="error"><span class="icon icon-danger"></span><span class="error-text">开始与结束日期不能为空</span></i>');
            	}
            	return;
            }else{
            	$("#JS_date_end").parent('.form-group').find('i[class="error"]').remove();
            }
            if (validateAdd.getIsValidate()) {
                //TODO 提交表单
                backstage.confirm({
                    content: "确认提交吗？",
                    determineCallback: function() {
                        $.ajax({
                            url: "/vst_admin/prod/destinationAnnouncement/saveOrUpdate.do",
                            type: "POST",
                            cache: false,
                            dataType : 'json',
							data : $form.serialize(),
                            success:
                                    function(data){
                                    	if(data.code=="success"){
                                            backstage.alert({
                                                content:"保存成功"
                                            });
                                            $("#announcementId").val(data.message);
                                            parent.location.reload();
                                    	}else{
                                    		backstage.alert({
			                                    content:"保存失败"
			                                });
                                    	}
                                    },
                            error: function () {
                                backstage.alert({
                                    content:"保存失败"
                                });
                            }
                        })
                    }
                });
            }
        });
    });
     $(function(){
		//绑定产品
		$(".JS_btn_bound").bind("click", function () {
            var announcementId = $("#announcementId").val();
	    	if(announcementId==null||announcementId==""){
	    		alert("请先保存公告");
	    		return;
	    	}
	    	location.href="/vst_admin/prod/destinationAnnouncement/toBind.do?id="+announcementId;
    	})

     })
</script>

</body>
</html>
