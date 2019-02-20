<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>编辑宝典导语</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/calendar.css,/styles/lv/buttons.css,/styles/lv/dialog.css,/styles/lv/icons.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/gallery/v1/reset.css,/styles/backstage/vst/gallery/v1/flat.css,/styles/backstage/vst/gallery/v1/gallery-backstage/display.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/gallery/v1/product-input/product-input-image-upload.css">
    <!-- 新添加-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst/gallery/v1/resources.css">
</head>
<body class="">

<div class="edit-manage">
    <div class="step-one">
        <p class="edit-step">编辑宝典导语</p>
        <div class="main edit-trip-box">
            <dl class="cf">
                <dt>
                    <i class="red">*</i>导语图片
                </dt>
                <dd>
                    <ul class="upload-add-image-ul" data-tag="guideImgs">
                        <li class="last-add-image" data-tag="addimg">
                            <a href="javascript:;"><i class="last-add-image-btn"></i>最多可上传6张图片</a>
                        </li>
                        <#list travelRecommendGuide as item>
                            <#if item.propType=='IMG'>
                                <li class="edit-add-pic <#if item.coverFlag=="Y">active</#if>" data-pic="${item.propValue}">
                                    <img src="http://pic.lvmama.com/${item.propValue}" width="210" height="140"/>
                                    <div class="upload-item-mask"></div>
                                    <div class="upload-item-delete JS-upload-item-delete"><i></i></div>
                                    <div class="upload-item-cover"><#if item.coverFlag=="Y">封面<#else>设为封面</#if></div>
                                </li>
                            </#if>
                        </#list>
                    </ul>
                </dd>
            </dl>
            <dl class="cf">
                <dt>
                    <i class="red">*</i>导语正文
                </dt>
                <dd>
                    <textarea maxlength="140" class="edit-tips js-edit-lead" placeholder="最多140字哦~"><#list travelRecommendGuide as item><#if item.propType=='GUIDE'>${item.propValue}</#if></#list></textarea>
                </dd>
            </dl>
            <div class="add-trip-box">
            	<#assign count=0 />
                <#list travelRecommendGuide as item>
                    <#if item.propType!='IMG' && item.propType!='GUIDE'>
                    	<#assign count=count+1 />
                        <div class="add-trip">
                            <dl class="cf">
                                <dt>
                                    行前准备
                                </dt>
                                <dd>
                                    <select class="form-control require-con require-con-box js-edit-select">
                                        <option value="VISA" <#if item.propType=="VISA">selected="selected"</#if>>签证</option>
                                        <option value="CURRENCY" <#if item.propType=="CURRENCY">selected="selected"</#if>>货币</option>
                                        <option value="BANKCARD" <#if item.propType=="BANKCARD">selected="selected"</#if>>银行卡</option>
                                        <option value="MEDICINE" <#if item.propType=="MEDICINE">selected="selected"</#if>>药品</option>
                                        <option value="PLUGIN" <#if item.propType=="PLUGIN">selected="selected"</#if>>电源插头</option>
                                        <option value="INHIBITION" <#if item.propType=="INHIBITION">selected="selected"</#if>>禁忌</option>
                                        <option value="DELETE">无</option>
                                    </select>
                                </dd>
                            </dl>
                            <dl class="cf">
                                <dt>
                                    准备说明
                                </dt>
                                <dd>
                                    <textarea maxlength="200" class="edit-tips " placeholder="最多200字哦~">${item.propValue}</textarea>
                                </dd>
                            </dl>
                            <div class="trip-btn-box">
                                <#if !item_has_next>
                                    <a class="btn trip-delete-btn" style="display: none;" >删除</a>
                                    <a class="btn trip-add-btn js-add-trip">+ 新增行程准备</a>
                                <#else>
                                    <a class="btn trip-delete-btn" >删除</a>
                                    <a class="btn trip-add-btn js-add-trip" style="display: none;">+ 新增行程准备</a>
                                </#if>
                            </div>
                        </div>
                    </#if>
                </#list>
                
                <#if count=0>
                	<div class="add-trip">
                            <dl class="cf">
                                <dt>
                                    	行前准备
                                </dt>
                                <dd>
                                    <select class="form-control require-con require-con-box js-edit-select">
                                    	<option value="">-请选择-</option>
                                        <option value="VISA">签证</option>
                                        <option value="CURRENCY">货币</option>
                                        <option value="BANKCARD">银行卡</option>
                                        <option value="MEDICINE">药品</option>
                                        <option value="PLUGIN">电源插头</option>
                                        <option value="INHIBITION">禁忌</option>
                                        <option value="DELETE">无</option>
                                    </select>
                                </dd>
                            </dl>
                            <dl class="cf">
                                <dt>
                                    	准备说明
                                </dt>
                                <dd>
                                    <textarea maxlength="200" class="edit-tips " placeholder="最多200字哦~"></textarea>
                                </dd>
                            </dl>
                            <div class="trip-btn-box">
                                <a class="btn trip-delete-btn" style="display: none;">删除</a>
                                <a class="btn trip-add-btn js-add-trip">+ 新增行程准备</a>
                            </div>
                     </div>
                </#if>	
            </div>
            <a class="btn btn-blue edit-save-btn js-edit-save-btn">保存</a>
        </div>
    </div>
</div>

<!--模板-->
<div class="edit-template" style="display: none">
    <!--新增行程准备 开始-->
    <div class="add-trip">
        <dl class="cf">
            <dt>
                行前准备
            </dt>
            <dd>
                <select class="form-control require-con require-con-box js-edit-select">
                    <option value="">-请选择-</option>
                    <option value="VISA">签证</option>
                    <option value="CURRENCY">货币</option>
                    <option value="BANKCARD">银行卡</option>
                    <option value="MEDICINE">药品</option>
                    <option value="PLUGIN">电源插头</option>
                    <option value="INHIBITION">禁忌</option>
                    <option value="DELETE">无</option>
                </select>
            </dd>
        </dl>
        <dl class="cf">
            <dt>
                准备说明
            </dt>
            <dd>
                <textarea maxlength="200" class="edit-tips " placeholder="最多200字哦~"></textarea>
            </dd>
        </dl>
        <div class="trip-btn-box">
            <a class="btn trip-delete-btn" style="display: none;">删除</a>
            <a class="btn trip-add-btn js-add-trip">+ 新增行程准备</a>
        </div>
    </div>
    <!--新增行程准备 END-->
    <!-- 新增图片 -->
    <li class="edit-add-pic">
        <img src="http://placehold.it/210x140/d9d9d9" width="210" height="140"/>
        <div class="upload-item-mask"></div>
        <div class="upload-item-delete JS-upload-item-delete"><i></i></div>
        <div class="upload-item-cover">设为封面</div>
    </li>
</div>
<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common.js,/js/lv/dialog.js,/js/lv/calendar.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/vst/gallery/v1/gallery-backstage/display.js"></script>
<script src="http://pic.lvmama.com/js/backstage/vst/gallery/v1/resources.js"></script>
<script>
    var pandora={
        dialog:{
            defaults:{}
        }
    };
</script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script>

    var uploadImgDialog;

    $("li[data-tag='addimg']").live("click",function(){
//        测试使用
//        addImg("uploads/pc/place2/2017-06-16/f7bdd1cb-20fe-4320-a09b-198a93bcbd9b.jpg");
//        return;

        var lilength = $("ul[data-tag='guideImgs'] li").length;
        if(lilength>=7){
            nova.alert("最多上传6张导语图片！");
            return false;
        }

        var url = "/photo-back/photo/photo/imgPlugIn.do?relationId=${recommendId}&relationType=1&imgLimitType=LIMIT_3_2_3L";
        uploadImgDialog=nova.dialog({
            url:true,
            content:url,
            width:838,
            initHeight:680,
            title:'上传图片',
            wrapClass:"upload-image-dialog"
        })
    });

    $("li.edit-add-pic").live("click",function(){
        $("li.edit-add-pic").removeClass("active");
        $("li.edit-add-pic").find("div.upload-item-cover").text("设为封面");
        $(this).addClass("active");
        $(this).find("div.upload-item-cover").text("封面");
    });

    $("select.js-edit-select").live("change",function(){
        if($(this).val()=="DELETE"){
            $(this).parents(".add-trip").find(".trip-delete-btn").trigger("click");
        }
    });

    /**
     * 上传图片回调函数
     * @param picob
     */
    function photoCallback(picob){
        window.console && console.log(picob);
        uploadImgDialog.close();
        if(picob!=null && picob.success==true){
            var photos=picob.photos;
            for(var i=0;i<photos.length;i++){
                addImg(photos[i].photoOriginUrl);
            }
        }else{
            //错误提示
            nova.dialog({
                content:"上传错误",
                wrapClass:"delete-all-dialog",
                time: 2000
            });
            window.console && console.log(picob);
        }
    }

    ///addImg("uploads/pc/place2/2017-06-16/f7bdd1cb-20fe-4320-a09b-198a93bcbd9b.jpg")
    function addImg(picurl){
        var lilength = $("ul[data-tag='guideImgs'] li").length;
        if(lilength>=7){
            nova.dialog({
				content:"最多上传6张图片！",
				okCallback: true,
			    okText: "确定",
			    okClassName:"btn-blue",
			    time:2000 //定时关闭 
			});
            return false;
        }
        var $tem = $(".edit-template").find(".edit-add-pic").clone();
        $("ul[data-tag='guideImgs']").append($tem);
        $tem.find("img").attr("src","http://pic.lvmama.com/"+picurl);
        $tem.attr("data-pic",picurl);
        return true;
    }


    $(function () {
        var $document = $(document);
        var $editTemplate = $(".edit-template");
        var $templateDetail = $(".template-detail");
        //新增行程准备
        $document.on("click",".js-add-trip",function () {
            var $this = $(this);
            var $tripBox = $this.parents(".add-trip");
            var $editTripBox = $this.parents(".add-trip-box");
            $this.hide();
            $tripBox.find(".trip-delete-btn").show();
            var $tem = $editTemplate.find(".add-trip").clone();
            $editTripBox.append($tem);
        });
        $document.on("click",".trip-delete-btn",function () {
            if($(".edit-trip-box").find(".trip-delete-btn").length==1){
                //仅剩下最后一个，先加一个出来再删除
                $(".edit-trip-box").find(".js-add-trip").eq(0).trigger("click");
            }
            $(this).parents(".add-trip").remove();
            //强制版面最后一个增加按钮显示
            $(".edit-trip-box").find(".js-add-trip:last").show();
        });
        $document.on("click",".JS-upload-item-delete",function () {
            var $this = $(this);
            $this.parent().remove();
            return false;
        });
        //第一步保存验证
        $document.on("click",".js-edit-save-btn",function () {
            var $this = $(this);
            var imglength = $("ul[data-tag='guideImgs'] li").length;
            //封装json提交
            var guideList=[];
            //验证图片
            if(imglength<=1){
                nova.dialog({
                    content:"导语至少包含一张图片",
                    wrapClass:"delete-all-dialog",
                    time: 2000
                });
                return false;
            }
            var hsaCoverFlag=false;
            $("ul[data-tag='guideImgs'] li").each(function () {
                if($(this).hasClass("active")){
                    hsaCoverFlag=true;
                }
            })
            //没有设置封面  给提示
            if(!hsaCoverFlag){
                nova.dialog({
                    content:"请给导语图片设置一张封面",
                    wrapClass:"delete-all-dialog",
                    time: 2000
                });
                return false;
            }
            //封装图片
            for(var i=1;i<$("ul[data-tag='guideImgs'] li").length;i++){
                var flag = "N";
                if($("ul[data-tag='guideImgs'] li").eq(i).hasClass("active")){
                    flag="Y";
                }
                var oneGuid = {
                    propValue:$("ul[data-tag='guideImgs'] li").eq(i).attr("data-pic"),
                    propType:'IMG',
                    coverFlag:flag
                };
                guideList.push(oneGuid);
            }
            //验证正文
            if($(".js-edit-lead").val() ==""){
                nova.dialog({
                    content:"导语正文不能为空",
                    wrapClass:"delete-all-dialog",
                    time: 2000
                });
                return false;
            }
            //封装正文
            {
                var oneGuid = {
                    propValue:$(".js-edit-lead").val(),
                    propType:'GUIDE',
                    coverFlag:'N'
                };
                guideList.push(oneGuid);
            }
            //验证和封装准备说明
            var $editHtml = $(".add-trip-box").find(".add-trip").find(".edit-tips");
            for(var i=0;i<$editHtml.length;i++){
                var $yzLength = $editHtml.eq(i).val();
                var select = $(".add-trip-box").find(".add-trip").find("select").eq(i);
                if(select.val()!=""){
                    if($yzLength == ""){
                        var selectName = $(".add-trip-box").find(".add-trip").find("select").eq(i).find("option[value='"+$(".add-trip-box").find(".add-trip").find("select").eq(i).val()+"']").text();
                        nova.dialog({
                            content:"准备说明【"+selectName+"】不能为空",
                            wrapClass:"delete-all-dialog",
                            time: 2000
                        });
                        return false;
                    }else{
                        var oneGuid = {
                            propValue:$yzLength,
                            propType:select.val(),
                            coverFlag:'N'
                        };
                        guideList.push(oneGuid);
                    }
                }
            }
            window.console && console.log(guideList);
            if(refreshSensitiveWord($("input[type='text'],textarea"))) {
            	nova.dialog({
					content:"内容含有敏感词,是否继续?",
					okCallback: function () {
						dosubmit(guideList);
					},
					okClassName:"btn-blue",
					okText: "确定",
					cancelCallback: true,
					cancelText: "取消",
					wrapClass:"delete-all-dialog"
				})
            }else{
                dosubmit(guideList);
            }

        });
        refreshSensitiveWord($("input[type='text'],textarea"));
    });

    function dosubmit(guideList){
        var loading = nova.loading('<div class="nova-dialog-body-loading"><i></i><br>正在提交中...</div>');
        $.ajax({
            url : "/vst_admin/superfreetour/travelRecommendGuide/updateTravelRecommendGuide.do",
            type : "post",
            dataType : 'json',
            data : {
                recommendId:${recommendId},
                guideStr: JSON.stringify(guideList)
            },
            success : function(result) {
                if(result.code == "success"){
                    nova.dialog({
						content:"保存成功！",
						okCallback: true,
					    okText: "确定",
					    okClassName:"btn-blue",
					    time:2000 //定时关闭 
					});
                }else {
                    nova.dialog({
						content:result.message,
						okCallback: true,
					    okText: "确定",
					    okClassName:"btn-blue",
					    time:2000 //定时关闭 
					});
                }
                loading.close();
            },
            error : function(){
            	loading.close();
            	nova.dialog({
						content:"保存失败！",
						okCallback: true,
					    okText: "确定",
					    okClassName:"btn-blue",
					    time:2000 //定时关闭 
					});
            }
        })
    }

</script>
</body>
</html>