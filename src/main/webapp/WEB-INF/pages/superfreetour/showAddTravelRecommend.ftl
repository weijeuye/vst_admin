<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/buttons.css,/styles/lv/dialog.css" />
    <style>
        .tags_1{
            margin: 1px;
            background-image: url(/vst_admin/img/right.jpg);
            background-size: cover;
            background-position: 100%,100%,center,center;
            height: 24px;
            cursor: pointer;
            display: inline-block;
            width: 24px;
            text-decoration: none;
        }
        .tags_1:hover{
        }
        .tags_2{
            margin: 1px;
            background-image: url(/vst_admin/img/error.jpg);
            background-size: cover;
            background-position: 100%,100%,center,center;
            height: 24px;
            cursor: pointer;
            display: inline-block;
            width: 24px;
            text-decoration: none;
        }
        .tags_3{
            margin: 1px;
            background-image: url(/vst_admin/img/edit.jpg);
            background-size: cover;
            background-position: 100%,100%,center,center;
            height: 24px;
            cursor: pointer;
            display: inline-block;
            width: 24px;
            text-decoration: none;
        }
        .tags_4{
            margin: 1px;
            background-image: url(/vst_admin/img/delete.jpg);
            background-size: cover;
            background-position: 100%,100%,center,center;
            height: 24px;
            cursor: pointer;
            display: inline-block;
            width: 24px;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="iframe_header">
    <!-- <ul class="iframe_nav">
        <li><a href="#">宝典维护</a> &gt;</li>
        <#if travelRecommendId??>
            <li class="active">修改宝典</li>
        <#else>
            <li class="active">添加宝典</li>
        </#if>
    </ul> -->
</div>
<div class="iframe_content mt10">
    <form action="/vst_admin/prod/travelRecommend/AddTravelRecommend.do" method="post" id="dataForm">
        <input type="hidden" name="sensitiveFlag" value="N">
        <div class="p_box box_info p_line">
            <div class="box_content">
                <table class="e_table form-inline">
                    <tbody>
                    <tr <#if travelRecommendId??><#else>style="display:none;"</#if>>
                        <td class="e_label"><i class="cc1">*</i>宝典ID：</td>
                        <td>
                            <input type="text" class="" name="travelRecommendId"  readonly = "readonly" value="${travelRecommendId!''}">
                        </td>
                    </tr>

                    <tr>
                        <td class="e_label"><i class="cc1">*</i>类别：</td>
                        <td colspan=3>
                            <input type="radio" name="recommendType" value="INNERLINE" required="" <#if travelRecommendVo?? && travelRecommendVo.recommendType=="INNERLINE">checked="checked"</#if>> 国内
                            <input type="radio" name="recommendType" value="FOREIGNLINE" required="" <#if travelRecommendVo?? && travelRecommendVo.recommendType=="FOREIGNLINE">checked="checked"</#if>> 出境/港澳台
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>宝典主标题：</td>
                        <td colspan=3>
                            <input type="text" class="w35" name="recommendName" value="${(travelRecommendVo.recommendName)!''}" required=""><br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>宝典副标题：</td>
                        <td colspan=3>
                            <textarea type="text" class="w35" name="viceName"  required="">${(travelRecommendVo.viceName)!''}</textarea>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>状态：</td>
                        <td colspan=3><select id="validFlag" name="validFlag" required="" value="Y" disabled="disabled" >
                            <option value="N" <#if (travelRecommendVo?? && travelRecommendVo.validFlag=="N") || travelRecommendVo==null>selected="selected"</#if> >无效</option>
                            <option value="Y" <#if (travelRecommendVo?? && travelRecommendVo.validFlag=="Y") >selected="selected"</#if> >有效</option>
                        </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label" width="100"><i class="cc1"></i>自定义标签：</td>
                        <td colspan=3>
                            <div id="tagsdiv">
                                <span id="tagsspan"></span>
                                <a class="btn" id="addtag">+&nbsp;新增标签</a> &nbsp;说明：勾选后标签在前台展示并被用于搜索
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1"></i>最佳游玩季节：</td>
                        <td>
                            <input type="text" class="w20" name="visitSeason" value="${(travelRecommendVo.visitSeason)!''}" >
                        </td>
                        <td class="e_label"><i class="cc1"></i>人均价格：</td>
                        <td>
                            <input type="text" class="w20" name="averageFee" value="${(travelRecommendVo.averageFee)!''}" >
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>宝典目的地：</td>
                        <td>
                            <input type="text" class="w20" id="destName" name="destName" value="${(travelRecommendVo.destName)!''}" readonly = "readonly" required>
                            <input type="hidden" name="destDistrictId" id="destDistrictId" value="${(travelRecommendVo.destDistrictId)!''}" />
                            <span type= "text" id="spanId_0" ></span>
                        </td>
                        <td class="e_label"><i class="cc1">*</i>推荐级别：</td>
                        <td>
                            <label><select name="recommendLevel" required>
                                <option value="5" <#if travelRecommendVo?? && travelRecommendVo.recommendLevel=="5">selected="selected"</#if> >5</option>
                                <option value="4" <#if travelRecommendVo?? && travelRecommendVo.recommendLevel=="4">selected="selected"</#if> >4</option>
                                <option value="3" <#if travelRecommendVo?? && travelRecommendVo.recommendLevel=="3">selected="selected"</#if> >3</option>
                                <option value="2" <#if (travelRecommendVo?? && travelRecommendVo.recommendLevel=="2") || travelRecommendVo==null>selected="selected"</#if> >2</option>
                                <option value="1" <#if travelRecommendVo?? && travelRecommendVo.recommendLevel=="1">selected="selected"</#if> >1</option>
                            </select>&nbsp;&nbsp;说明：由数字越高推荐级别越高</label>
                        </td>
                    </tr>
                    <tr>
                        <td class="e_label"><i class="cc1">*</i>产品经理：</td>
                        <td>
                            <input type="text" class="w35 searchInput" name="managerName" id="managerName" required value="${(travelRecommendVo.managerName)!''}">
                            <input type="hidden" name="managerId" id="managerId" value="${(travelRecommendVo.managerId)!''}">
                        </td>
                        <td class="e_label"><i class="cc1">*</i>所属组织：</td>
                        <td>
                            <select name="filiale" class="filialeCombobox" id="filiale" required>
                                <option value="">请选择</option>
                            <#list filiales as filiale>
                                <option value="${filiale.code}" <#if travelRecommendVo?? && travelRecommendVo.filiale==filiale.code>selected="selected"</#if> >${filiale.cnName}</option>
                            </#list>
                            </select>
                        </td>
                    </tr>
                    <tr id="buTr">
                        <td class="e_label"><i class="cc1">*</i>所属BU：</td>
                        <td colspan=3>
                            <select name="bu" id="bu" required>
                                <option value="">请选择</option>
                            <#list buList as list>
                                <option value=${list.code!''} <#if travelRecommendVo?? && travelRecommendVo.bu==list.code>selected="selected"</#if>>${list.cnName!''}</option>
                            </#list>
                            </select>
                        </td>
                    </tr>


                    </tbody>
                </table>
            </div>
        </div>


    <div class="p_box box_info">
    </form>
</div>
<div class="fl operate" style="margin:20px;width: 100%;">
    <div style="margin:0 auto;width:250px;">
        <a class="btn btn_cc1" id="save">保存</a><a class="btn btn_cc1" id="saveAndNext">保存并维护下一步</a>
    </div>
</div>
<#include "/base/foot.ftl"/>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/kindeditor-4.0.2/plugins/image/image.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/kindEditorConf.js?v1"></script>
<script type="text/javascript" src="http://pic.lvmama.com/min/index.php?f=/js/lv/dialog.js"></script>
</body>
</html>
<script>

    //目的地维护开始
    var dests = [];//子页面选择项对象数组
    var count =0;
    var markDest;
    var markDestId;
    var spanId;

    // 中文字两个字节
    jQuery.validator.addMethod("byteRangeLength", function(value, element, param) {
        var length = value.length;
        for(var i = 0; i < value.length; i++){
            if(value.charCodeAt(i) > 127){
                length++;
            }
        }
        return this.optional(element) || ( length >= param[0] && length <= param[1] );
    }, $.validator.format("最多{1}字符哦~"));

    $(document).ready(function(){
        //打开选择行政区窗口
        $("input[name='destName']").live("click",function(){
            markDest = $(this).attr("id");
            markDestId = $(this).next().attr("id");
            spanId = $(this).next().next().attr("id");
            var url = "/vst_admin/biz/dest/selectDestList.do?destType=CITY&type=main&selectDestTypeList=CITY";
            destSelectDialog = new xDialog(url,{},{title:"选择目的地",iframe:true,width:"1000",height:"600"});
        });

        //模糊查询产品经理数据
        vst_pet_util.superUserSuggest("#managerName", "input[name=managerId]");

        $("#dataForm").validate({
            rules : {
                recommendName : {
                    byteRangeLength : [1,50]
                },
                viceName : {
                    byteRangeLength : [1,100]
                },
                visitSeason : {
                    byteRangeLength : [0,20]
                },
                averageFee : {
                    byteRangeLength : [0,20]
                }
            }
        })

        //保存
        $("#save").click(function(){
            dosubmit(false);
        });

        //保存并继续
        $("#saveAndNext").click(function(){
            dosubmit(true);
        });

        //自定义标签
        $("#addtag").click(function(){
            createTag("",false,true);
        });

        //点击删除
        $(".tags_4").live("click",function(){
            $(this).parent().remove();
        });

        //点击修改
        $(".tags_3").live("click",function(){
            $(this).hide();
            $(this).parent().find(".tags_4").show();
            $(this).parent().find("input[name='tag']").removeAttr("readonly");
            $(this).parent().find("input[name='tag']").trigger("focus");
        });

        //加载标签
        <#if travelRecommendVo?? && travelRecommendVo.travelRecommendTagReVoList??>
            <#list travelRecommendVo.travelRecommendTagReVoList as tagReVo>
            <#if tagReVo.tagStatus=='Y'>
                createTag("${tagReVo.tagName}",true,false);
            <#else>
                createTag("${tagReVo.tagName}",false,false);
            </#if>
            </#list>
        </#if>
        refreshTagSensitiveWord($("input[type='text'],textarea"));
    });


    //自定义标签敏感词
    function refreshTagSensitiveWord(array){
        var hasSensitive = false;
        $(".has_senisitive").remove();
        for(var i=0;i<array.length;i++){
            var obj = $(array[i]);
            if(!obj.is(":hidden") && $.trim(obj.val())!=""){
                //如果是日期类型，不校验
                if(obj.is(".Wdate")){
                    continue;
                }
                //如果是纯数字，不校验
                var number = /^[0-9]+$/;
                if(number.test($.trim(obj.val()))){
                    continue;
                }

                //如果是readonly或者disabled则不验证
//                if((obj.is(":disabled") || (obj.attr("readonly")=='readonly'))&& !obj.is(".sensitive_validate")){
//                    continue;
//                }

                $.ajax({
                    url : "/vst_admin/prod/product/sensitiveWord.do",
                    type : "post",
                    data : {word:obj.val()},
                    async : false,
                    success : function(result) {
                        if(result.message!=""){
                            hasSensitive = true
                            if(obj.is(".searchInput")){
                                obj.next().next().next().after('<span class="has_senisitive" style="color:red">有敏感词:'+result.message+'</span>');
                            }else{
                                obj.after('<span class="has_senisitive" style="color:red">有敏感词:'+result.message+'</span>');
                            }

                        }
                    },
                    error : function(){

                    }
                });
            }
        }
        return hasSensitive;
    }


    //构造标签
    function createTag(name,check,isadd){
        var checked = "";
        if(check==true){
            checked = "checked='checked'";
        }
        var oneTag=$('<div data-tag="tags" style="float:left;margin: 0 5px;"><input type="checkbox" name="tagcheck" '+checked+' >'
                +'<input type="text" class="w10 searchInput" style="margin: 1px;" name="tag" value="'+name+'" required maxlength=6>'
                +'<a class="tags_3"  data-tag="edit"></a>'
                +'<a class="tags_4"  data-tag="delete"></a>'
                +'</div>');
        $("#tagsspan").before(oneTag);
        if(isadd==true) {
            oneTag.find(".tags_3").hide();
            oneTag.find("input[name='tag']").trigger("focus");
        }else{
            oneTag.find(".tags_4").hide();
            oneTag.find("input[name='tag']").attr("readonly","readonly");
        }
        suchTags(oneTag.find("input.searchInput"));
    }

    //搜索标签
    function suchTags(showNode) {
        showNode.jsonSuggest({
            url : "/vst_admin/prod/travelRecommend/searchTags.do",
            maxResults : 10,
            minCharacters : 1,
            onSelect : function(item) {
            }
        });
    }

    //验证并提交表单
    function dosubmit(nextAction){
        $.each( $("input[autoValue='true']"), function(i, n){
            if($(n).val()==""){
                $(n).val($(n).attr('placeholder'));
            }
        });

        if(!$("#dataForm").valid()){
            $(this).removeAttr("disabled");
            return false;
        }

        //设置自定义标签checkbox值
        $("div[data-tag='tags']").each(function(){
           $(this).find("input[name='tagcheck']").val($(this).find("input[name='tag']").val());
        });

        var msg = '确认保存吗 ？';
        if(refreshTagSensitiveWord($("input[type='text'],textarea"))){
            $("input[name='sensitiveFlag']").val("Y");
            msg = '内容含有敏感词,是否继续?'
        }else {
            $("input[name='sensitiveFlag']").val("N");
        }

        $("#save").hide();
        $("#saveAndNext").hide();
        $("#validFlag").removeAttr("disabled");
        var dataSerialize = $("#dataForm").serialize();
        $("#validFlag").attr("disabled","disabled");
        nova.dialog({
			content:msg,
			okCallback: function(){
	            //遮罩层
	            var loading = top.pandora.loading("正在努力保存中...");
	            $.ajax({
	                url : "/vst_admin/prod/travelRecommend/addTravelRecommend.do",
	                type : "post",
	                dataType : 'json',
	                data : dataSerialize,
	                success : function(result) {
	                    loading.close();
	                    if(result.code == "success"){
	                        //为子窗口设置productId
	                        $("input[name='travelRecommendId']").val(result.attributes.travelRecommendId);
	                        //为父窗口设置productId
	                        $("#travelRecommendId",window.parent.document).val(result.attributes.travelRecommendId);
	                        $("#recommendName",window.parent.document).val(result.attributes.recommendName);
	                        if(nextAction==true){
	                        	nova.dialog({
									content:result.message,
									okCallback: function(){
	                                    //跳转下一个输入页面
	                                    $("#traveRecommendRouteGuide",parent.document).parent("li").trigger("click");
	                                },
								    okText: "确定",
								    okClassName:"btn-blue"
								});
	                        }else{
	                        	nova.dialog({
									content:result.message,
									okCallback: function(){
	                                    parent.checkAndJump();
	                                },
								    okText: "确定",
								    okClassName:"btn-blue"
								});
	                        }
	                    }else {
	                        nova.dialog({
									content:result.message,
									okCallback: true,
								    okText: "确定",
								    okClassName:"btn-blue"
								});
	                        $("#save").show();
	                        $("#saveAndNext").show();
	                    }
	                },
	                error : function(){
	                    $("#save").show();
	                    $("#saveAndNext").show();
	                    loading.close();
	                }
	            })
	        },
            okClassName:"btn-blue",
			okText: "确定",
			cancelCallback: function(){
				$("#save").show();
            	$("#saveAndNext").show();
			},
			beforeClosingCallback: function () {
				$("#save").show();
            	$("#saveAndNext").show();
			},
			cancelText: "取消",
			wrapClass:"delete-all-dialog"
		});
    }


    //选择目的地
    function onSelectDest(params){
        window.console && console.log(params);
        if(params!=null){
            $("#"+markDest).val(params.destName + "[" + params.destType + "]");
            $("#"+markDestId).val(params.districtId);
            if(params.parentDest==""){
                $("#"+spanId).html("");
            }else{
                $("#"+spanId).html("上级目的地："+params.parentDest);
            }
        }
        destSelectDialog.close();
        $("#"+markDest).trigger("keyup");
    }
</script>