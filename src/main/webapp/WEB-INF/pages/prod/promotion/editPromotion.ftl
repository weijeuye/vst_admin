<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>基本信息页面</title>
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
                <label for="descName">
                    <span class="text-danger">*</span> 活动名称：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="descName" id="descName" value="${desc.descName!''}" type="text" class="form-control w200" data-validate-regular="^\d*$" data-validate="{required:true}" maxlength="20"/>
                </div>

                <span class="text-gray">（用于前台展示活动时标签中的内容显示）</span>
            </dd>
            <dt>
                <label for="descId">
                    <span class="text-danger">*</span> 活动ID：
                </label>
            </dt>
            <dd>
                <div class="form-group col mr10">
                    <input name="descId" id="descId" value="${desc.descId!''}" type="text" class="form-control w200" data-validate-regular="^\d*$" data-validate="{required:true}" readonly="readonly"/>
                </div>
            </dd>
            <dt>
                <label for="activeName">
                    <span class="text-danger">*</span> 活动展示时间设置：
                </label>
            </dt>
            <dd>
                <div class="active_calendar inline-block w500">
                         <span class="form-group">
                            <input name="descStartTime" type="text" value="${desc.descStartTimeStr!''}" placeholder="" class="form-control datetime w100" id="JS_date_start" onClick="WdatePicker()" readonly="readonly"/>
                        </span>
                    至
                        <span class="form-group">
                            <input name="descEndTime"  type="text" value="${desc.descEndTimeStr!''}" placeholder="" class="form-control datetime w100" id="JS_date_end"  onClick="WdatePicker({minDate:'#F{$dp.$D(\'JS_date_start\')}'})" readonly="readonly"/>
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
                </div>
            </dd>
            <dt>
                <label for="buCode">
                    <span class="text-danger">*</span>所属BU：
                </label>
            </dt>
            <dd class="form-group">
                <select name="buCode" class="form-control w115 " id = 'descBu' data-validate="{required:true}">
                	<option value="">请选择</option>
                    <#list buList as list>
		                <option value=${list.code!''} >${list.cnName!''}</option>
			        </#list>
                </select>
            </dd>
            <dt>
                <label for="seq">
                    <span class="text-danger">*</span>活动排序值：
                </label>
            </dt>
            <dd class="form-group">
                <select class="form-control w115 JS_activeSort" name="seq" data-validate="{required:true}">
                    <option value="">请选择</option>
                    <option>6</option>
                    <option>5</option>
                    <option>4</option>
                    <option>3</option>
                    <option>2</option>
                    <option>1</option>
                </select>
                <span class="text-gray active_twoLine w440">（用于前台，当一个产品有多个活动说明时，排序值越大就越靠前；排序值相同按照活动说明ID大小判断，ID大的靠前）</span>
            </dd>
            <dt>
                <label for="descDescription">
                    活动描述内容：
                </label>
            </dt>
            <dd>
                <textarea name="descDescription" class="active_textarea form-control" maxlength="1000">${desc.descDescription!''}</textarea>
            </dd>
            <dt>
                <label for="activeName">
                    添加活动图片：
                </label>
            </dt>
            <dd class="unloadPic">
                <#list list as photolist> 
	                <div class="nchActivepicture">
	                	<span class="close">X</span>
	                	<p class="picNumber">${photolist.photoId}</p>
	                    <input type="hidden" name="photoUrl" id="photoUrl" value="${photolist.photoUrl}"/>
	                    <img src="http://pic.lvmama.com${photolist.photoUrl}" width="180" height="120" alt=""/>
                        <p class="imgInfo">${photolist.photoContent}</p>
	                </div>
                </#list>
                <div class="nchaddPictureBtn"></div>
            </dd>
        </dl>
        <div class="btn-group text-center">
        	<#if isEdit??>
            	<a class="btn btn-primary JS_btn_save">保存</a>
            </#if>
            <a class="btn btn-primary JS_btn_bound" target="_parent" id="bind-button" data-descId="${desc.descId!''}">绑定产品</a>

        </div>
    </form>
</div>

<!--页面结束-->
<!--脚本模板开始-->
<div class="template">
    <!--保存成功-->
    <div class="dialog-saveSuccess">
        <iframe src="about:blank" class="iframe-saveSuccess" frameborder="0"></iframe>
    </div>
    <!--基本信息-->
    <div class="dialog-addBaseInformation">
        <iframe src="about:blank" class="iframe-addBaseInformation" frameborder="0"></iframe>
    </div>
</div>



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
	var basePath="";
	var submitFlag = false;
	var skipFlag = false;
	var imageDialog;
	$(function () {
		//初始化渠道
		var channelCode = "${desc.channelList!''}";
		var $checkbox = $("input[type='checkbox']");
		for(var i in $checkbox){
			if(channelCode.indexOf($checkbox[i].value) != -1){
				$checkbox[i].checked="checked";
			}
		} 
		//初始化bu
		var buCode = "${desc.buCode!''}";
		var $buOption = $("select[name='buCode'] option");
		for(var i in $buOption){
			if(buCode == $buOption[i].value){
				$buOption[i].selected = true;
			}
		} 
		//活动排序
		var seq = "${desc.seq!''}";
		var $seqOption = $("select[name='seq'] option");
		for(var i in $seqOption){
			if(seq == $seqOption[i].value){
				$seqOption[i].selected = true;
			}
		} 
	});
    var $document = $(document);

    //TODO 开发维护
    $(function () {

        var $template = $(".template");
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
            if($("#descDescription").val()=='' && $("#photoUrl").size()==0){
            	alert('添加描述内容跟添加活动图片必填一项');
            	return;
            }
            if (validateAdd.getIsValidate()) {
                //TODO 提交表单
                backstage.confirm({
                    content: "确认提交吗？",
                    determineCallback: function() {
                    submitFlag = true;
                        $.ajax({
                            url: "/vst_admin/prod/promotion/desc/edit.do",
                            type: "POST",
                            cache: false,
                            dataType : 'json',
							data : $form.serialize(),
                            success:
                                    function(data){
                                    	if(data.code=="success"){
	                                        var $addAttach = $template.find(".dialog-saveSuccess").clone();
	                                        window.addAttachDialog = backstage.dialog({
	                                            title: "",
	                                            width: 450,
	                                            height:132,
	                                            $content: $addAttach
	                                        });
	
	                                        var url = "/vst_admin/prod/promotion/desc/toSaveSuc.do";
	                                        var $iframe = $addAttach.find(".iframe-saveSuccess");
	                                        $iframe.attr("src", url);
                                    	}else{
                                    		backstage.alert({
			                                    content:data.message
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
    //删除图片
    $(function(){
        //删除图片 开始
        $document.on("click",'.nchActivepicture .close', function(){
            $(this).parent().remove();
        });
        //鼠标移上图片盒子，关闭按钮出现
        $document.on("mouseenter",'.nchActivepicture', function () {
            $(this).find('.close').show();
        });
        //鼠标移上图片盒子，关闭按钮隐藏
        $document.on("mouseleave",'.nchActivepicture', function () {
            $(this).find('.close').hide();
        });
    })
    $(function(){
         //新添加日历 开始
	    $("#JS_date_start").each(function(){
	        $(this).ui("calendar",{
	            input : this,
	            parm:{dateFmt:'yyyy-MM-dd'}
	        })
	    })
	    //新添加日历 结束
    })
    $(function () {
    	var $form = $(".baseInformation").find("form");
    	var oldForm = $form.serialize();
    	var $template = $(".template");
    	var validateAdd = backstage.validate({
            $area: $form,
            REQUIRED: "不能为空",
            showError: true
        });
    	$("#bind-button").bind("click", function () {
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
            if($("#descDescription").val()=='' && $("#photoUrl").size()==0){
            	alert('添加描述内容跟添加活动图片必填一项');
            	return;
            }
            if (!validateAdd.getIsValidate()) {
            	return;
            }
    		var newForm = $form.serialize();
    	 	if(!submitFlag && oldForm!=newForm){
	    	 	backstage.confirm({
	                content: "基本信息有修改,是否保存？",
	                determineCallback: function() {
						 $.ajax({
	                        url: "/vst_admin/prod/promotion/desc/edit.do",
	                        type: "POST",
	                        cache: false,
	                        dataType : 'json',
							data : $form.serialize(),
	                        success:
	                                function(data){
	                                	if(data.code=="success"){
	                                		skipFlag = true;
	                                        var $addAttach = $template.find(".dialog-saveSuccess").clone();
	                                        window.addAttachDialog = backstage.dialog({
	                                            title: "",
	                                            width: 450,
	                                            height:132,
	                                            $content: $addAttach
	                                        });
	
	                                        var url = "/vst_admin/prod/promotion/desc/toSaveSuc.do";
	                                        var $iframe = $addAttach.find(".iframe-saveSuccess");
	                                        $iframe.attr("src", url);
	                                	}else{
	                                		skipFlag = true;
	                                		backstage.alert({
			                                    content:data.message
			                                });
	                                	}
	                                },
	                        error: function () {
	                            backstage.alert({
	                                content:"保存失败"
	                            });
	                        }
	                    })
					 },
					 cancelCallback: function () {
					 	var descId=$("#bind-button").attr("data-descId");
	    				location.href="/vst_admin/prod/promotion/desc/toBind.do?descId="+descId;
       				 },
				 })
    	 	}else{
    	 		var descId=$("#bind-button").attr("data-descId");
	    		location.href="/vst_admin/prod/promotion/desc/toBind.do?descId="+descId;
    	 	}
    	})
    })
    
    $(function(){
    	//上传图片
		$(".nchaddPictureBtn").bind("click", function () {
            var url = "/pic/photo/photo/imgPlugIn.do";
            imageDialog = new xDialog(url,{},{title:"图片列表",iframe:true,width:"950px",height:"630px"});
    	})
    	
     })
     
     function photoCallback(photoJson, extJson){
		if(photoJson != null && photoJson !=''){
			if(photoJson.photos) {
				for(var ps in photoJson.photos) {
					$(".nchaddPictureBtn").before('<div class="nchActivepicture">' +
						'<span class="close">X</span>'+
						'<p class="picNumber">'+ photoJson.photos[ps].photoId +'</p>'+
						'<input type="hidden" name="photoUrl" id="photoUrl" value="' + photoJson.photos[ps].photoUpdateUrl + '"/>'+
   						'<img src="http://pic.lvmama.com'+photoJson.photos[ps].photoUpdateUrl+'" width="180" height="120" alt=""/>' +
   						'<p class="imgInfo">'+ photoJson.photos[ps].photoName +'</p></div>');
				}
			} else if(photoJson.photo) {
				$(".nchaddPictureBtn").before('<div class="nchActivepicture">' +
						'<span class="close">X</span>'+
						'<p class="picNumber">'+ photoJson.photo.photoId +'</p>'+
						'<input type="hidden" name="photoUrl" id="photoUrl" value="' + photoJson.photo.photoUpdateUrl + '"/>'+
   						'<img src="http://pic.lvmama.com'+photoJson.photo.photoUpdateUrl+'" width="180" height="120" alt=""/>' +
   						'<p class="imgInfo">'+ photoJson.photo.photoName +'</p></div>');
			}
		}
		imageDialog.close();
	}
</script>

</body>
</html>
