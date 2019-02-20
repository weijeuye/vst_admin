<!DOCTYPE html>
<#assign picMap={"ONE":"pf-movable-picture-one","ONE-TITLE":"pf-movable-picture-one-with-title","TWO":"pf-movable-picture-two","THREE":"pf-movable-picture-three","CUSTOM":"pf-movable-picture-custom"}>
<#assign picWidth={"ONE":"1080","ONE-TITLE":"1080","TWO":"530","THREE":"347","CUSTOM":"1080"}>
<#assign picheight={"ONE":"432","ONE-TITLE":"432","TWO":"353","THREE":"231","CUSTOM":""}>
<#assign ulClass={"ONE":"yin-section-img-large","ONE-TITLE":"yin-section-img-large","TWO":"yin-section-img-big","THREE":"yin-section-img-small","CUSTOM":"yin-section-img-diy"}>
<html>
<head>
    <meta charset="UTF-8">
    <title>新版本录入</title>
    <link rel="shortcut icon" href="http://www.lvmama.com/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/base.css"/>
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/gallery/v1/reset.css,/styles/backstage/vst/gallery/v1/flat.css,/styles/backstage/vst/gallery/v1/product-input/product-input-carousel.css">
    <link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/product-feature/product-feature.css">
    <link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
    <link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css"/> 
    <style>
    .dialog-header{
    
    line-height: 30px;
    height: 30px;
    background: #538ED7;
    padding: 0 10px;
    color: #FFF;
    font-weight: bold;
    font-size: 14px;
    }
    .pf-richText{
    position:relative;margin:5px 0;background:#FFF;left:40px;
    }
    .pf-richContent{
    position:relative;left:60px;top: -25px;
    }
    .word_surplus{
    position: relative;
    left: 610px;
    top: 367px;
    }
    
    </style>
   
</head>
<body class="product-feature">
<input type="hidden" id="hasHead" name="hasHead" value="${hasHead}">
<input type="hidden" id="divIndex" value="">
<input type="hidden" id="userName"  value="${userName}">
<input type="hidden" name="senisitiveFlag" value="N">
<input type="hidden" id="editFlag" name="editFlag" value="${editFlag}">
<input type="hidden" id="maxIndex" value="${(ProdRouteFeatureList?size)!''}">
<!--页面 开始-->
<div class="everything">

    <!--洋葱皮 开始-->
    <ol class="onionskin">
        <li>
            <a href="#">
            <#if categoryId==15>跟团游</#if>
            <#if categoryId==16>当地游</#if>
            <#if categoryId==17>酒店套餐</#if>
            <#if categoryId==18>自由行</#if>
            <#if categoryId==32>酒套餐</#if>
            </a>
            &gt;
        </li>
        <li>
            <a href="#">产品维护</a>
            &gt;
        </li>
        <li>
            产品特色
        </li>
    </ol>
    <!--洋葱皮 结束-->
	<form id="prodRouteFeatureForm" name="prodRouteFeatureFrom">
		<input type="hidden" id="productId" name="productId" value="${productId}">
		<input type="hidden" id="associatedFeatureId" name="associatedFeatureId" value="${associatedFeatureId}">
		<input type="hidden" id="packageType" name="packageType" value="${packageType}">
		<div id="featureHiddenDiv" style="display:none">
			
        </div>
	</form>
    <!--头部 开始-->
    <div class="pf-header">

        <p class="pf-tip">产品特色新增新版本的录入方式啦~</p>
        

        <div class="pf-tabs clearfix"  <#if hasHead=="false">style="display:none;"</#if>>
            <a class="active">新版本</a>
            <!--<#if editFlag == 'false'>
            <a href="showProductRouteFeatureOld.do?productId=${associatedFeatureId}&categoryId=${associatedcategoryId}&packageType=${packageType}">旧版本</a>
            <#else>
            <a href="showProductRouteFeatureOld.do?productId=${productId}&categoryId=${categoryId}&packageType=${packageType}">旧版本</a>
            </#if>-->
            <a href="showProductRouteFeatureOld.do?productId=${productId}&categoryId=${categoryId}&associatedFeatureId=${associatedFeatureId}&packageType=${packageType}">旧版本</a>
        </div>

        <p class="pf-tip">* 鼠标按住已添加的“大标题”“正文”等标签，可以上下拖动。</p>
        <#if associatedFeatureId??>
        <p class="pf-tip">已关联产品ID：${associatedFeatureId}，当前界面不可修改。</p>
        </#if>
        <div class="pf-func clearfix">
            <div class="pull-left">
                <a class="btn btn-primary JS_btn_save">保存</a>
                
            </div>
            <div class="pull-right">
            	<#if hasRichText=="true">
            		<a class="btn btn-primary JS_btn_copy_richText">复制产品富文本</a>
            	</#if>
                <#if packageType =="LVMAMA" && subCategoryId !=181 && categoryId!=16>
                	<a class="btn btn-primary JS_btn_copy_other">其他产品特色</a>
            	<#else>
                	<a class="btn btn-primary JS_btn_copy">复制产品特色</a>
            	</#if>   
              	<a class="btn btn-primary JS_btn_view">预览效果</a>
            </div>
        </div>

    </div>
    <!--头部 结束-->

    <!--主体 开始-->
    <div class="pf-main">
    	<!--占位元素 开始-->
        <div class="pf-hold"></div>
        <!--占位元素 结束-->
        <#if hasRichText=="true">
    		<div id ='richText'class="pf-richText" featproptype="RICH_TEXT">
			    <label class="pf-label">
			            富文本：
			        </label>
			        <span class="word_surplus">富文本框高度：<span class="now_word_surplus" >0/600</span></span>
	    		<div class="pf-richContent">
					<textarea class="w35 featureRichText textWidth"  style="width:758px;height: 350px;" mark='featureRichText0'
					placeholder="富文本内容为可选项，可根据产品特色添加富文本内容，输入不得大于600px"> 
					<#if featPropValue??>${featPropValue}<#else><span class="richtext-span">富文本内容为可选项，可根据产品特色添加富文本内容，输入不得大于600px</span></#if>
			   		</textarea>
		   		</div>
	   		</div>
	   		
    	</#if>
    <#if ProdRouteFeatureList?? && ProdRouteFeatureList?size &gt; 0> 
	    <#list ProdRouteFeatureList as  ProdRouteFeature>
	    	<#if ProdRouteFeature.featPropType?? && ProdRouteFeature.featPropType=="BIG_TITLE">
	    	<!--大标题 开始-->
	        <div class="pf-movable pf-movable-big-title" featPropType="BIG_TITLE" divIndex="div${ProdRouteFeature_index}">
	            <input type="hidden" value="001" name="movableId">
	            <label class="pf-label">
	                <i class="pf-label-icon"></i>
	               	 大标题：
	            </label>
	            <div class="pf-content">
	            	<form>
		                <span class="form-group pf-error-left clearfix">
		                    <label class="pf-label-strong">
		                        <input type="radio" name="bigTitle" value="HOTEL" <#if ProdRouteFeature.featPropValue?? && ProdRouteFeature.featPropValue=="HOTEL">checked="checked"</#if> data-validate="{required:true}">
		                     	   酒店介绍
		                    </label>
		                    <label class="pf-label-strong">
		                        <input type="radio" name="bigTitle" value="VIEW_PORT" <#if ProdRouteFeature.featPropValue?? && ProdRouteFeature.featPropValue=="VIEW_PORT">checked="checked"</#if> data-validate="{required:true}">
		                       	 景点介绍
		                    </label>
		                    <label class="pf-label-strong">
		                        <input type="radio" name="bigTitle" value="FOOD" <#if ProdRouteFeature.featPropValue?? && ProdRouteFeature.featPropValue=="FOOD">checked="checked"</#if> data-validate="{required:true}">
		                        	美食推荐
		                    </label>
		                    <label class="pf-label-strong">
		                        <input type="radio" name="bigTitle" value="TRAFFIC" <#if ProdRouteFeature.featPropValue?? && ProdRouteFeature.featPropValue=="TRAFFIC">checked="checked"</#if> data-validate="{required:true}">
		                      	  交通信息
		                    </label>
		                    <label class="pf-label-strong pf-label-short">
		                        <input class="" type="radio" name="bigTitle" value="OTHER"
		                        	<#if ProdRouteFeature.featPropValue?? && (ProdRouteFeature.featPropValue!="HOTEL" && 
		                        												ProdRouteFeature.featPropValue!="VIEW_PORT" && 
		                        												ProdRouteFeature.featPropValue!="FOOD" && 
		                        												ProdRouteFeature.featPropValue!="TRAFFIC")>checked="checked"</#if>
		                               data-validate="{required:请选择一个大标题！若不需要，可删除。}">
		                       	 自定义
		                    </label>
		                </span>
		                <span class="form-group">
		                <div class="pf-text-bigTitleOther" style="display:none;">${ProdRouteFeature.featPropValue}</div>
	                    <input type="text" name="bigTitleOther" class="input-text pf-title-text" placeholder="请输入大标题，限100个字"
	                    		<#if ProdRouteFeature.featPropValue?? && (ProdRouteFeature.featPropValue!="HOTEL" && 
		                        												ProdRouteFeature.featPropValue!="VIEW_PORT" && 
		                        												ProdRouteFeature.featPropValue!="FOOD" && 
		                        												ProdRouteFeature.featPropValue!="TRAFFIC")> value="大标题" <#else> value="" </#if>
	                           data-validate="{required:请输入大标题！若不需要，可删除。}" disabled="disabled" maxlength="100">
	                	</span>
	                </form>
	            </div>
	            <div class="pf-btn-box">
	                <a class="btn JS_movable_del">删除</a>
                    <label>
                       <input type="radio" name="product-insert-position">
                       选择插入
                    </label>
	            </div>
	        </div>
	        <!--大标题 结束-->
	    	</#if>
	    	<#if ProdRouteFeature.featPropType?? && ProdRouteFeature.featPropType=="SMALL_TITLE">
	    	<!--小标题 开始-->
	        <div class="pf-movable pf-movable-small-title" featPropType="SMALL_TITLE" divIndex="div${ProdRouteFeature_index}">
	            <input type="hidden" value="001" name="movableId">
	            <label class="pf-label">
	                <i class="pf-label-icon"></i>
	                	小标题：
	            </label>
	            <div class="pf-content">
	                <span class="form-group">
	                    <div class="pf-text-smallTitle" style="display:none;">${ProdRouteFeature.featPropValue}</div>
	                    <input type="text" name="smallTitle" value="" class="input-text pf-title-text" placeholder="这是小标题，100个汉字以内，一个汉字含一个字符，可以字符汉字混合展示。"
	                           data-validate="{required:请输入小标题！若不需要，可删除。}" maxlength="100">
	                </span>
	            </div>
	            <div class="pf-btn-box">
	                <a class="btn JS_movable_del">删除</a>
                    <label>
                       <input type="radio" name="product-insert-position">
                       选择插入
                    </label>
	            </div>
	        </div>
	        <!--小标题 结束-->
	    	</#if>
	    	<#if ProdRouteFeature.featPropType?? && ProdRouteFeature.featPropType=="TEXT">
	    		<!--正文 开始-->
	        <div class="pf-movable pf-movable-text" featPropType="TEXT" divIndex="div${ProdRouteFeature_index}">
	            <input type="hidden" value="001" name="movableId">
	            <label class="pf-label">
	                <i class="pf-label-icon"></i>
	               	 正文：
	            </label>
	            <div class="pf-content">
	                <span class="form-group">
	                    <div <#if editFlag=="true"> contenteditable="true"</#if> class="input-text pf-text-edit"><p>${ProdRouteFeature.featPropValue?replace("&nbsp;"," ")}</p></div>
	                    <input type="hidden" name="text"  class="pf-text-edit-hidden"
	                           data-validate="{required:请输入正文！若不需要，可删除。,maxlength:正文超过了最多字数限制2000汉字}"
	                           data-validate-maxlength="2000" value="">
	                </span>
	            </div>
	            <div class="pf-btn-box">
	                <a class="btn JS_movable_del">删除</a>
                    <label>
                       <input type="radio" name="product-insert-position">
                       选择插入
                    </label>
	            </div>
	        </div>
	        <!--正文 结束-->
	    	</#if>
	    	<#if ProdRouteFeature.featPropType?? && ProdRouteFeature.featPropType=="IMG">
	    		<div class="pf-movable ${picMap[ProdRouteFeature.prodFeaturePic.templateType]}" data-class="${picMap[ProdRouteFeature.prodFeaturePic.templateType]}" featPropType="IMG" divIndex="div${ProdRouteFeature_index}">
			        <input type="hidden" value="001" name="movableId">
			        <label class="pf-label">
			            <i class="pf-label-icon"></i>
			            	图片：
			        </label>
			        <div class="pf-content">
			            <ul class="yin-section-img ${ulClass[ProdRouteFeature.prodFeaturePic.templateType]} clearfix">
			            	<#if ProdRouteFeature.prodFeaturePic.picSrc?? && ProdRouteFeature.prodFeaturePic.picSrc?size gt 0>
			            	<#list ProdRouteFeature.prodFeaturePic.picSrc as picSrc>
			                <li>
			                    <img name="${picSrc.name}" src="${picSrc.src}" alt="" width="${picWidth[ProdRouteFeature.prodFeaturePic.templateType]}" height="${picheight[ProdRouteFeature.prodFeaturePic.templateType]}">
			                    <#if ProdRouteFeature.prodFeaturePic.templateType == "ONE-TITLE">
			                    <p>${ProdRouteFeature.prodFeaturePic.text}</p>
			                    </#if>
			                </li>
			                </#list>
			                </#if>
			            </ul>
			
			        </div>
			        <div class="pf-btn-box">
			            <a class="pf-btn btn-primary btn JS_movable_edit">编辑</a>
			            <a class="pf-btn btn JS_movable_del">删除</a>
                        <label>
                            <input type="radio" name="product-insert-position">
                                                                          选择插入
                       </label>
			        </div>
			    </div>
	    	</#if>
		</#list>
	<#else>
        <!--大标题 开始-->
        <div class="pf-movable pf-movable-big-title" featPropType="BIG_TITLE">
            <input type="hidden" value="001" name="movableId">
            <label class="pf-label">
                <i class="pf-label-icon"></i>
               	 大标题：
            </label>
            <div class="pf-content">
            	<form>
	                <span class="form-group pf-error-left clearfix">
	                    <label class="pf-label-strong">
	                        <input type="radio" name="bigTitle" value="HOTEL"   data-validate="{required:true}">
	                     	   酒店介绍
	                    </label>
	                    <label class="pf-label-strong">
	                        <input type="radio" name="bigTitle" value="VIEW_PORT"  data-validate="{required:true}">
	                       	 景点介绍
	                    </label>
	                    <label class="pf-label-strong">
	                        <input type="radio" name="bigTitle" value="FOOD"  data-validate="{required:true}">
	                        	美食推荐
	                    </label>
	                    <label class="pf-label-strong">
	                        <input type="radio" name="bigTitle" value="TRAFFIC" data-validate="{required:true}">
	                      	  交通信息
	                    </label>
	                    <label class="pf-label-strong pf-label-short">
	                        <input class="" type="radio" name="bigTitle" value="OTHER" 
	                               data-validate="{required:请选择一个大标题！若不需要，可删除。}">
	                       	 自定义
	                    </label>
	                </span>
	                <span class="form-group">
	                    <input type="text" name="bigTitleOther" class="input-text pf-title-text" placeholder="请输入大标题，限100个字"
	                           data-validate="{required:请输入大标题！若不需要，可删除。}" disabled="disabled" maxlength="100">
	                </span>
                </form>
            </div>
            <div class="pf-btn-box">
                <a class="btn JS_movable_del">删除</a>
                <label>
                       <input type="radio" name="product-insert-position">
                                                           选择插入
                </label>
            </div>
        </div>
        <!--大标题 结束-->

        <!--小标题 开始-->
        <div class="pf-movable pf-movable-small-title" featPropType="SMALL_TITLE">
            <input type="hidden" value="001" name="movableId">
            <label class="pf-label">
                <i class="pf-label-icon"></i>
                	小标题：
            </label>
            <div class="pf-content">
                <span class="form-group">
                    <input type="text" name="smallTitle" class="input-text pf-title-text" placeholder="这是小标题，100个汉字以内，一个汉字含一个字符，可以字符汉字混合展示。"
                           data-validate="{required:请输入小标题！若不需要，可删除。}" maxlength="100">
                </span>
            </div>
            <div class="pf-btn-box">
                <a class="btn JS_movable_del">删除</a>
                <label>
                       <input type="radio" name="product-insert-position">
                                                           选择插入
                </label>
            </div>
        </div>
        <!--小标题 结束-->

        <!--正文 开始-->
        <div class="pf-movable pf-movable-text" featPropType="TEXT">
            <input type="hidden" value="001" name="movableId">
            <label class="pf-label">
                <i class="pf-label-icon"></i>
               	 正文：
            </label>
            <div class="pf-content">
                <span class="form-group">
                    <div <#if editFlag=="true"> contenteditable="true" </#if> class="input-text pf-text-edit"><p><br></p></div>
                    <input type="hidden" name='text' class="pf-text-edit-hidden"
                           data-validate="{required:请输入正文！若不需要，可删除。,maxlength:正文超过了最多字数限制2000字}"
                           data-validate-maxlength="2000">
                </span>
            </div>
            <div class="pf-btn-box">
                <a class="btn JS_movable_del">删除</a>
                <label>
                       <input type="radio" name="product-insert-position">
                                                            选择插入
                </label>
            </div>
        </div>
        <!--正文 结束-->
    </#if>
    </div>
    <!--主体 结束-->

    <!--底部 开始-->
    <div class="pf-footer">
        <div class="pf-func clearfix">
            <div class="pull-left">
                <a class="btn btn-primary JS_btn_save">保存</a>
                <a class="showLogDialog btn btn-primary JS_btn_log " param='objectId=${productId}&objectType=PROD_PRODUCT_FEATURE&sysName=VST'>操作日志</a>
            </div>
        </div>

    </div>
    <!--底部 结束-->

</div>
<!--页面 结束-->

<!--浮动 开始-->
<div class="pf-float-pane">

    <div class="pf-float-pane-title">
        选择添加：
    </div>
    <ul>
        <li><a class="btn JS_main_add_big_title">+ 大标题</a></li>
        <li><a class="btn JS_main_add_small_title">+ 小标题</a></li>
        <li><a class="btn JS_main_add_text">+ 正文</a></li>
        <li><a class="btn JS_main_add_picture">+ 图片</a></li>
    </ul>

</div>
<!--浮动 结束-->

<!--模板 开始-->
<div class="template">
    <!--大标题模板 开始-->
    <div class="pf-movable pf-movable-big-title" featPropType="BIG_TITLE">
        <input type="hidden" value="001" name="movableId">
        <label class="pf-label">
            <i class="pf-label-icon"></i>
            大标题：
        </label>
        <div class="pf-content">
        	<form>
                <span class="form-group pf-error-left clearfix">
                    <label class="pf-label-strong">
                        <input type="radio" name="bigTitle" value="HOTEL"  data-validate="{required:true}">
                       	 酒店介绍
                    </label>
                    <label class="pf-label-strong">
                        <input type="radio" name="bigTitle" value="VIEW_PORT"  data-validate="{required:true}">
                       	 景点介绍  
                    </label>
                    <label class="pf-label-strong">
                        <input type="radio" name="bigTitle" value="FOOD"  data-validate="{required:true}">
                       	 美食推荐
                    </label>
                    <label class="pf-label-strong">
                        <input type="radio" name="bigTitle" value="TRAFFIC" data-validate="{required:true}">
                       	 交通信息
                    </label>
                    <label class="pf-label-strong pf-label-short">
                        <input class="" type="radio" name="bigTitle" value="OTHER" data-validate="{required:请选择一个大标题！若不需要，可删除。}">
                       	 自定义
                    </label>
                </span>
                <span class="form-group">
                    <input type="text" name="bigTitleOther" class="input-text pf-title-text" placeholder="请输入大标题，限100个字"
                           data-validate="{required:请输入大标题！若不需要，可删除。}" disabled="disabled" maxlength="100">
                </span>
         	</form>
        </div>
        <div class="pf-btn-box">
            <a class="btn JS_movable_del">删除</a>
            <label>
                    <input type="radio" name="product-insert-position">
                    选择插入
            </label>
        </div>
    </div>
    <!--大标题模板 结束-->

    <!--小标题模板 开始-->
    <div class="pf-movable pf-movable-small-title" featPropType="SMALL_TITLE">
        <input type="hidden" value="001" name="movableId" >
        <label class="pf-label">
            <i class="pf-label-icon"></i>
            小标题：
        </label>
        <div class="pf-content">
                <span class="form-group">
                    <input type="text" name='smallTitle' class="input-text pf-title-text" placeholder="这是小标题，100个汉字以内，一个汉字含一个字符，可以字符汉字混合展示。"
                           data-validate="{required:请输入小标题！若不需要，可删除。}" maxlength="100">
                </span>
        </div>
        <div class="pf-btn-box">
            <a class="btn JS_movable_del">删除</a>
            <label>
                <input type="radio" name="product-insert-position">
                选择插入
            </label>
        </div>
    </div>
    <!--小标题模板 结束-->

    <!--正文模板 开始-->
    <div class="pf-movable pf-movable-text" featPropType="TEXT">
        <input type="hidden" value="001" name="movableId" >
        <label class="pf-label">
            <i class="pf-label-icon"></i>
            正文：
        </label>
        <div class="pf-content">
                <span class="form-group">
                    <div <#if editFlag=="true"> contenteditable="true" </#if> class="input-text pf-text-edit"><p><br></p></div>
                    <input type="hidden" name='text' class="pf-text-edit-hidden"
                           data-validate="{required:请输入正文！若不需要，可删除。,maxlength:正文超过了最多字数限制2000字}"
                           data-validate-maxlength="2000">
                </span>
        </div>
        <div class="pf-btn-box">
            <a class="btn JS_movable_del">删除</a>
             <label>
                <input type="radio" name="product-insert-position">
                选择插入
            </label>
        </div>
    </div>
    <!--正文模板 结束-->
    <#include "/prod/packageTour/product/addPicture.ftl"/>
    <!--预览 开始-->
    <div class="pf-view-template JS_view_template">
    </div>
    <!--预览 结束-->
</div>
<!--模板 结束-->
<script src="/vst_admin/js/dujia/dujia-common.js"></script>
<!--公用脚本 START-->
<script src="http://pic.lvmama.com/min/index.php?f=/js/new_v/jquery-1.7.2.min.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common/dialog.js,js/backstage/v1/common/validate.js,js/backstage/v1/common/float-alert.js,js/backstage/v1/common/sortable.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/vst/product-feature/product-feature.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/feature/kindeditor-4.0.2/kindeditor.js"></script>
<script type="text/javascript" src="/vst_admin/js/contentManage/featureKindEditorConf.js?v1"></script>

<!--公用脚本 END-->
<script>
	var $currentPictureTemplate=null;
	var imageOperate=null;
    //复制产品的弹窗
    var copyFeatureDialog=null;
    //预览弹窗
    var previewDialog=null;
	function imageOperateDialogDestroy(){
		imageOperate.destroy();
	}
	//刷新 敏感词校验（小标题，正文,大标题）
    var $elements = $("textarea,input[name='smallTitle'],input[name='text'],input[name='bigTitleOther'],text,hidden,text");
	var dataObjRich=[];
	
   $(function(){ 	
   		$(".featureRichText").each(function(){
			var mark=$(this).attr('mark');
		 	var t = lvmamaEditor.editorCreate('mark',mark);
		 	dataObjRich.push(t);
		});
        //TODO 请开发维护，并保存到开发服务器中
        var $document = $(document);
        var $template = $(".template");
        var $main = $(".pf-main");

        //当前操作中的图片
        var $currentPicture = null;
        var picTemplate=null;
        
        var imageOperate2=null;
		var imageOperate3=null;
		//页面关联则不可修改
		 $(document).ready(function (){
	     if($("#editFlag").val() == "false"){
		       	$("input[type='radio']").attr("disabled",true);
		       	$("input").attr("readonly",true);
//		       	$document.unbind("click");
			}	
		//复制关联产品特色  
		$document.on("click", ".JS_btn_copy_other", function() {
	        destoryDialog(copyFeatureDialog);
	        var $content = $("<div><p>说明：<br/>1、引用：即可跨品类复制产品特色，且可编辑<br/>2、关联：即关联其他产品的产品特色，不可编辑，两者之间信息同步</p></div>"+
	        "<div id='type' style='margin-top:10px; margin-left:100px;'><label><p>类型：</p></label>"+
	        "<input type='radio' name='copyType' value='copyOnly'/>引用"+
	        "<input type='radio' name='copyType' value='related' />关联</div>"+
	        "<div style='margin-top:10px; margin-left:100px;'><label><p>产品ID：</p></label>"+
	        "<input type='text' value='' id='copyProductId' maxlength='11' ></div>"+
	        "<div class='pf-insert-pane-btn-group' style='margin-left:150px;margin-top:30px;width:450px;''>"+
	        "<a class='btn JS_copy_btn_ok2'>确定</a><a class='btn JS_copy_btn_cancel' href='javascript:'>取消</a></div>");
	        copyFeatureDialog = backstage.dialog({
	            width: 450,
	            height: 220,
	            title: "系统提示",
	            $content: $content,
	            padding: 10
	        });
	
	    });
	    
		 //复制产品特色去取消按钮事件
	    $document.on("click", ".JS_copy_btn_cancel", function() {
	        destoryDialog(copyFeatureDialog);
	    });
	    
	    //引用或者关联确认
	    $document.on("click", ".JS_copy_btn_ok2", function() {
	        var copyProductId = $("#copyProductId").val();
	        var type = $('#type input[name="copyType"]:checked ').val();
	        if (!copyProductId || copyProductId == "") {
	            backstage.alert({
	                title: "系统提示",
	                content: "请输入产品ID"
	            });
	            return;
	        }
	        var chars = /^[0-9]*[1-9][0-9]*$/; //验证正整数  
	        if (!chars.test(copyProductId)) {
	            backstage.alert({
	                title: "系统提示",
	                content: "产品ID请输入正整数"
	            });
	            return;
	        }
	        if(copyProductId==$("input[name='productId']").val()){
	             backstage.alert({
	                title: "系统提示",
	                content: "不能复制自己的产品特色"
	            });
	            return;
	        }
			 if (!type || type == "") {
	            backstage.alert({
	                title: "系统提示",
	                content: "请选择类型：引用或者关联！"
	            });
	            return;
	        }
	        backstage.confirm({
	            width: 450,
	            height: 180,
	            title: "标题",
	            content: "<p><b>引用或者关联其他产品特色后，原有的产品特色将会被覆盖。请确认</b></p>",
	            determineCallback: function() {
	                //确定时执行
	                copyProdFeature(copyProductId);
	            },
	            cancelCallback: function() {
	                //取消与关闭时执行
	                destoryDialog(copyFeatureDialog);
	            }
	        });
	    });
	    
	   
		       	
 });
     if($("#editFlag").val() != "false"){
        /*拖动*/
        backstage.sortable({
            $box: $(".pf-main"),
            $hold: $(".pf-hold"),
            itemQuery: ".pf-movable",
            itemMoveQuery: ".pf-label",
            movingClassName: "moving",
            callback: function () {
                //拖动回调函数
            }
        });
    }
        /*初始化input值*/
		$(".pf-text-edit").each(function(){
        		var $this=$(this);
 	      		var text = getPlainTxtWithWrap($this);
		        $this.next(".pf-text-edit-hidden").val(text).change();
         });
         
         $(".pf-text-smallTitle").each(function(){
                var $this=$(this);
             	var text = $this.text();
                $this.next("[name=smallTitle]").val(text);
         });
         
         $(".pf-text-bigTitleOther").each(function(){
                var $this=$(this);
                var text = $this.text();
               	if(text!="HOTEL" && text!="FOOD" && text!="VIEW_PORT" && text!="TRAFFIC"){
                         $this.next("[name=bigTitleOther]").val(text);
                }
          });
        
        /*大标题自定义*/
        $document.on("change", ".pf-movable-big-title .pf-label-strong>:radio", function () {
            var $this = $(this);
            var $bigTitle = $this.parents(".pf-movable-big-title");
            var $text = $bigTitle.find(".pf-title-text");

            if ($this.val() === "OTHER") {
                $text.attr("disabled", false).show();
                validateSensitiveWord($elements, true);
            } else {
                $text.attr("disabled", true).hide();
                var validate = backstage.validate({
                    REQUIRED: "您还有未填写项",
                    $area: $bigTitle,
                    showError: true
                });
                validate.test();  //表单验证
                $bigTitle.find(".has_senisitive").remove();
            }
		 
        });
        
        /*初始化大标题自定义*/
		$("input[name='bigTitleOther']").each(function(){
		    var $this=$(this);
			var $parentDiv=$this.parents(".pf-content");
			var checked=$parentDiv.find("input[value='OTHER']").attr("checked");
			if($(this).val()!=null && $(this).val()!="" && checked=="checked"){
				$(this).attr("disabled", false).show();
			}
		});
		/*大标题自定义验证*/
        $document.on("change", ".pf-movable-big-title .pf-title-text", function () {
           var $this = $(this);
           if($this.val()=="HOTEL"||$this.val()=="VIEW_PORT"||$this.val()=="FOOD"||$this.val()=="TRAFFIC"){
           	      backstage.alert({
                        title: "系统提示",
                        content: "大标题自定义禁止输入"+$this.val()
                    });
           	     $this.val("");
           }
        });
		
		multipleList();
		//刷新时敏感词验证
       validateSensitiveWord($elements,true);
      
        function validateFrom(){
        	var $area = $(".pf-main");
            $area.find("input[placeholder],textarea[placeholder]").each(function () {
                var $this = $(this);
                var placeholder = $this.attr("placeholder");
                var value = $this.val();
                if(placeholder === value) {
                    $this.val("");
                }
            });
            var validate = backstage.validate({
                REQUIRED: "您还有未填写项",
                $area: $area,
                showError: true,
                $ERROR: $('<i class="error"><span class="error-text"></span></i>')
            });
            validate.test();  //表单验证
            validate.watch();  //表单监视，表单中内容发生改版，立即验证一次
            //获取是否验证通过
            //console.log(validate.getIsValidate());
            //跳转到错误处
            if (!validate.getIsValidate()) {
                var $errorArea = $area.find("i.error").eq(0).parents(".pf-movable");
                var nowTop = $(window).scrollTop();
                var endTop = $errorArea.offset().top - 100;
                var diffHeight = Math.abs(endTop - nowTop);

                var timeDelay = diffHeight / 4;
                if (timeDelay > 1000) {
                    timeDelay = 1000;
                } else if (timeDelay < 100) {
                    timeDelay = 100;
                }
                $('html,body').stop(true, true).animate({scrollTop: endTop}, timeDelay);
                return false;
        	}else{
        		return true;
        	}
        }
	if($("#editFlag").val() != "false"){
        /*保存提示*/
        $document.on("click", ".JS_btn_save", function () {
            initContentByFormat("");
			var isValidate = validateFrom();
			if(!isValidate){
				return;
			}
            initContentByFormat("nbsp;");
            var hasRichText = "${hasRichText}";
            if(hasRichText=="true"){
            	var autoheight =window.frames[0].frames.frameElement.contentDocument.body.scrollHeight;
	            if(parseInt(autoheight)>600){
	            	alert("富文本输入内容超过上限");
	            	return;
	            }
	            if(dataObjRich[0]!=null){
		            var temp = dataObjRich[0].html();
		            if(temp.length>3500){
	        			alert("富文本样式过多,无法保存，请清除样式后重新设置");
	        			return;
	        		}
        		}
        		$(".featureRichText").text(dataObjRich[0].text());
            }
        //判断是否含有敏感字（产品名称、供应商产品名称、产品经理推荐、产品详情）
        if (validateSensitiveWord($elements,false)){
            $("input[name=senisitiveFlag]").val("Y");
            backstage.confirm({
                width: 450,
                height: 180,
                title: "标题",
                content: "<p>内容含有敏感词，是否继续？</p>",
                determineCallback: function() {
                    //确定时执行
                    submitFeature();
                },
                cancelCallback: function() {
                    //取消与关闭时执行
                }
            });

        }else{
			$("input[name=senisitiveFlag]").val("N");
             submitFeature();
        }
        });
  }      
        //查看旧版本
        $document.on("click", "#showOldFeature", function () {
			setFeatureHiddenDiv();
			var $form=$("#prodRouteFeatureForm");
			$form.attr("action","/vst_admin/packageTour/prod/product/showProductRouteFeatureOld.do");
			$form.submit();
        });
       
       //提交产品特色
       function submitFeature() {
         if ($("#hasHead").val() == "true") {
            backstage.confirm({
                width: 450,
                height: 180,
                title: "标题",
                content: "<p>如果保存并使用新版本，产品上线后，网站展示的产品特色将采用新版本，旧版本将被删掉。<b>请确认新版本已经编辑好。</b></p>" +
                    "<p class='strong'>确定旧版本删掉，保存并使用新版本么？</p>",
                determineCallback: function() {
                    //确定时执行
                    submitForm();
                },
                cancelCallback: function() {
                    //取消与关闭时执行
                }
            });
        } else {
            submitForm();
        }

     }

        function submitForm(){
        	setFeatureHiddenDiv();
        	$.ajax({
				url : "/vst_admin/packageTour/prod/product/updateProductFeature.do",
				type : "post",
				dataType : 'json',
				data : $("#prodRouteFeatureForm").serialize(),
				success : function(result) {
					if(result.code == "success"){
				    	backstage.alert({
			            	content: "<i class='pf-icon pf-icon-big pf-icon-success'></i>&nbsp;保存成功",
			            	callback: function () {
					   			window.location.reload();
					   		}
			            });
				   	} else {
						alert(result.message);
				 	}
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
        }
        
        function toHtmlForFeatureOld(){
        
        	$(".JS_view_template").html("");
	        $("#featureHiddenDiv").find("input[name='featureProp']").each(function(){
		    	var obj=$(this);
		    	var featureProp=obj.val();
		    	var index=featureProp.indexOf("`");
		    	var propType=featureProp.substring(0,index);
		    	var propValue=featureProp.substring(index+1,featureProp.length);
		    	if(propType=="BIG_TITLE"){
		    		var bigTitleHtml=getBigTitle(propValue);
		    		$(".JS_view_template").append(bigTitleHtml);
		    	}else if(propType=="SMALL_TITLE"){
		    		var smallTitleHtml='<div style="font-size: 16px;color: #333;line-height: 24px;margin-bottom: 6px;">'+propValue+'</div>';
		    		$(".JS_view_template").append(smallTitleHtml);
		    	}else if(propType=="TEXT"){
		    		var textHtml='<div style="font-size: 14px;line-height: 22px;color: #666;margin-bottom: 10px;">'+propValue+'</div>';
		    		$(".JS_view_template").append(textHtml);
		    	}else{ //图片预览
		    		var dataObj=eval("("+propValue+")");//转换为json对象 
		    		if(dataObj.templateType=="ONE"){
		    			
		    			var imgHtml='<div style="font-size: 0; margin-bottom: 20px;"><img style="width: 100%;" src="'+dataObj.picSrc[0].src+'" alt="" width="1080" height="432"></div>';
		    			$(".JS_view_template").append(imgHtml);
		    		}if(dataObj.templateType=="ONE-TITLE"){
		    			var imgHtml='<div style="font-size: 0; margin-bottom: 20px;"><img style="width: 100%;" src="'+dataObj.picSrc[0].src+'" alt="" width="1080" height="432"></div>';
				        $(".JS_view_template").append(imgHtml);
		    		}if(dataObj.templateType=="TWO"){
		    			var imgHtml='<div style="font-size: 0;  margin-bottom: 20px;">'+
							            '<span style="width: 530px;height: 353px;margin-right: 20px;display: inline-block;">'+
							                '<img style="width: 530px;height: 353px;" src="'+dataObj.picSrc[0].src+'" alt="" width="530" height="353">'+
							            '</span>'+
							            '<span style="width: 530px;height: 353px;margin-right:0;display: inline-block;">'+
							               '<img style="width: 530px;height: 353px;" src="'+dataObj.picSrc[1].src+'" alt="" width="530" height="353">'+
							            '</span>'+
							        '</div>';
		    			$(".JS_view_template").append(imgHtml);
		    		}if(dataObj.templateType=="THREE"){
		    			var imgHtml='<div style="font-size: 0; margin-bottom: 20px;">'+
							            '<span style="width: 347px;height: 231px;margin-right: 19px;display: inline-block;">'+
							                '<img style="width: 347px;height: 231px;" src="'+dataObj.picSrc[0].src+'" alt="" width="347" height="231">'+
							            '</span>'+
							            '<span style="width: 347px;height: 231px;margin-right: 19px;display: inline-block;">'+
							                '<img style="width: 347px;height: 231px;" src="'+dataObj.picSrc[1].src+'" alt="" width="347" height="231">'+
							            '</span>'+
							            '<span style="width: 347px;height: 231px;margin-right:0;display: inline-block;">'+
							                '<img style="width: 347px;height: 231px;" src="'+dataObj.picSrc[2].src+'" alt="" width="347" height="231">'+
							            '</span>'+
							        '</div>';
		    			$(".JS_view_template").append(imgHtml);
		    		}if(dataObj.templateType=="CUSTOM"){
			    		var imgHtml='<div style="font-size: 0; margin-bottom: 20px;">'+
							            '<img style="width: 100%;" src="'+dataObj.picSrc[0].src+'" alt="" width="1080">'+
							       '</div>';
		    			$(".JS_view_template").append(imgHtml);
		    			
          			}
		    	}
		    });
        }
        function getBigTitle(bigtitleType){
            var bigtitleStyle="";
            var bigtieleText="";
            var spanEnStyle="";
            if(bigtitleType=="HOTEL"){
                bigtitleStyle="";
                bigtieleText="酒店介绍";
                spanEnStyle=' 0 -630px';
            }else if(bigtitleType=="VIEW_PORT"){
                bigtitleStyle="yin-section-scenic";
                bigtieleText="景点介绍";
                spanEnStyle=' 0 -669px';
            }else if(bigtitleType=="FOOD"){
                bigtitleStyle="yin-section-food";
                bigtieleText="美食推荐";
                spanEnStyle=' 0 -710px';
            }else if(bigtitleType=="TRAFFIC"){
                bigtitleStyle="yin-section-traffic";
                bigtieleText="交通信息";
                spanEnStyle=' 0 -750px';
            }else{
                bigtitleStyle="yin-section-else";
                bigtieleText=bigtitleType;
            }

            if(spanEnStyle==""){
            var html='<div style="margin-bottom: 15px;padding-bottom: 10px;border-bottom: 1px solid #E3E3E3;"><div style="font-size: 20px;color: #333;line-height: 20px;">'+bigtieleText+'</div></div>';
            }else{
            var html='<div style="margin-bottom: 15px;padding-bottom: 10px;border-bottom: 1px solid #E3E3E3;"><div style="font-size: 20px;color: #333;line-height: 20px;"><span style="width: 88px;float: left;font-size: 20px;color: #333;line-height: 20px;border-right: 1px solid #E3E3E3;">'+bigtieleText+'</span><span style="display: inline-block;height: 20px;width: 200px;background: url(http://pic.lvmama.com/img/line/product-detail-all.png)  '+spanEnStyle+';"></span></div></div>';
            }
            return html;
        }
        
        function setFeatureHiddenDiv(){
        	$("#featureHiddenDiv").html("");
        	$(".pf-main >.pf-movable").each(function(){//遍历所有输入项，的上级容器
        		var featureTypeContent=$(this);
        		var featPropType=featureTypeContent.attr("featPropType");
          		if(featPropType=="BIG_TITLE"){// 如果是大标题容器
          			featureTypeContent.find("input[name='bigTitle']").each(function(){//遍历大标题容器下的所有单选按钮
          				var bigTitleRadio=$(this);
          				if(bigTitleRadio.attr("checked")=="checked"){
          					var type="BIG_TITLE";
          					var value="";
          					if(bigTitleRadio.val()!="OTHER"){
          						value=bigTitleRadio.val();
          					}else{
          						value=featureTypeContent.find("input[name='bigTitleOther']").val();
          					}
          					if(value!==null && value!=""){
          					    var $otherTitle=$("<input type='hidden' name='featureProp' value=''/>");
                                $otherTitle.val(type+"`"+value);
          						$("#featureHiddenDiv").append($otherTitle);
          					}
          					
          				}
          			});
          		}
          		if(featPropType=="SMALL_TITLE"){
          			var value=featureTypeContent.find("input[name='smallTitle']").val();
          			if(value!==null && value!=""){
          				var $smallTitle=$("<input type='hidden' name='featureProp' value='' />");
          				$smallTitle.val("SMALL_TITLE`"+value);
          				$("#featureHiddenDiv").append($smallTitle);
          			}
          		}
          		if(featPropType=="TEXT"){
          			var value=featureTypeContent.find("input[name='text']").val();
          			if(value!==null && value!=""){
          			    var $text=$("<input type='hidden' name='featureProp' value='' />");
          			    $text.val("TEXT`"+value);
          				$("#featureHiddenDiv").append($text);
          			}
          		}
          		if(featPropType=="IMG"){
          			//data-class="pf-movable-picture-one-with-title"
          			var picTemplate = featureTypeContent.attr("data-class");
          			if(picTemplate=="pf-movable-picture-one"){
          				var obj=new Object();
          				obj.templateType="ONE";
          				var arr=new Array();
          				var img=new Object();
          				img.src=featureTypeContent.find("img[name='img11']").attr("src");
          				img.name=featureTypeContent.find("img[name='img11']").attr("name");
          				arr.push(img);
          				obj.picSrc=arr;
          				$("#featureHiddenDiv").append("<input type='hidden' name='featureProp' value='IMG`"+JSON.stringify(obj)+"' />");
          			}
          			if(picTemplate=="pf-movable-picture-one-with-title"){
          				var obj=new Object();
          				obj.templateType="ONE-TITLE";
          				obj.text=featureTypeContent.find("p").html();
          				var arr=new Array();
          				var img=new Object();
          				img.src=featureTypeContent.find("img[name='img12']").attr("src");
          				img.name=featureTypeContent.find("img[name='img12']").attr("name");
          				arr.push(img);
          				obj.picSrc=arr;
          				$("#featureHiddenDiv").append("<input type='hidden' name='featureProp' value='IMG`"+JSON.stringify(obj)+"' />");
          			}
          			if(picTemplate=="pf-movable-picture-two"){
          				var obj=new Object();
          				obj.templateType="TWO";
          				var arr=new Array();
          				var img=new Object();
          				img.src=featureTypeContent.find("img[name='img21']").attr("src");
          				img.name=featureTypeContent.find("img[name='img21']").attr("name");
          				arr.push(img);
          				
          				var img2=new Object();
          				img2.src=featureTypeContent.find("img[name='img22']").attr("src");
          				img2.name=featureTypeContent.find("img[name='img22']").attr("name");
          				arr.push(img2);
          				
          				obj.picSrc=arr;
          				$("#featureHiddenDiv").append("<input type='hidden' name='featureProp' value='IMG`"+JSON.stringify(obj)+"' />");
          			}
          			if(picTemplate=="pf-movable-picture-three"){
          				var obj=new Object();
          				obj.templateType="THREE";
          				var arr=new Array();
          				var img=new Object();
          				img.src=featureTypeContent.find("img[name='img31']").attr("src");
          				img.name=featureTypeContent.find("img[name='img31']").attr("name");
          				arr.push(img);
          				
          				var img2=new Object();
          				img2.src=featureTypeContent.find("img[name='img32']").attr("src");
          				img2.name=featureTypeContent.find("img[name='img32']").attr("name");
          				arr.push(img2);
          				
          				var img3=new Object();
          				img3.src=featureTypeContent.find("img[name='img33']").attr("src");
          				img3.name=featureTypeContent.find("img[name='img33']").attr("name");
          				arr.push(img3);
          				
          				obj.picSrc=arr;
          				$("#featureHiddenDiv").append("<input type='hidden' name='featureProp' value='IMG`"+JSON.stringify(obj)+"' />");
          			}
          			if(picTemplate=="pf-movable-picture-custom"){
          				var obj=new Object();
          				obj.templateType="CUSTOM";
          				var arr=new Array();
          				var img=new Object();
          				img.src=featureTypeContent.find("img[name='img41']").attr("src");
          				img.name=featureTypeContent.find("img[name='img41']").attr("name");
          				arr.push(img);
          				obj.picSrc=arr;
          				$("#featureHiddenDiv").append("<input type='hidden' name='featureProp' value='IMG`"+JSON.stringify(obj)+"' />");
          			}
          			
          		}
			});
			toHtmlForFeatureOld();
			var htmlForFeatureOld ='<div style="margin: 0 auto;font-family:Microsoft Yahei,sans-serif;">'+ $(".JS_view_template").html()+'</div>';
			var $htmlForFeature=$("<input type='hidden' name='htmlForFeature' id='htmlForFeature' value='' />");
			$htmlForFeature.val(htmlForFeatureOld);
			$("#featureHiddenDiv").append($htmlForFeature);
			if(dataObjRich[0]!=null){
				var $richTextVal=$("<input type='hidden' name='richTextVal' id='richTextVal' value='' />");
				var temp = dataObjRich[0].html();
				var text = dataObjRich[0].text();
	        	if(text!="富文本内容为可选项，可根据产品特色添加富文本内容，输入不得大于600px"){
	        		 text = text.replace(/(\n)/g,"");
	        		if(text==""){
			       		temp="";
			        }else{
			            if(temp.indexOf("div")<0){
			                temp="<div style='margin-bottom:10px;'>"+temp+"</div>";
			            }
			        }
			        if(temp.length>3500){
			            alert("富文本样式过多,无法保存，请清除样式后重新设置");
			        }else{
			            $richTextVal.val(temp);
			            $("#featureHiddenDiv").append($richTextVal);
			        }
	        	}
			}
			
        }
        

        /*预览效果*/
        $document.on("click", ".JS_btn_view", function () {
            initContentByFormat("");
			var isValidate = validateFrom();
			if(!isValidate){
				return;
			}
            else {
                initContentByFormat("&nbsp;");
            	setFeatureHiddenDiv();
                destoryDialog(previewDialog);
                previewDialog = backstage.dialog({
	                title: "预览效果",
	                iframe: true,
	                url: "previewProdFeature.do",  //内容：支持jQuery对象与HTML文本
	                width: 1130,  //宽度
	                height: 500,  //高度
	                padding: 5,  //内边距
	                className: "pf-dialog-view",
	                callback: function () {
	                    //关闭时执行
	                }
	            });
                
                $("<div class='dialog-close' style='margin-right:600px;'>×</div>").insertBefore($(".pf-dialog-view .dialog-close"));
                $(".pf-dialog-view").on('click', '.dialog-close', function() {
                        destoryDialog(previewDialog);
                });

            }

        });
        //页面unbind后重新绑定预览
 //       if($("#editFlag").val() == "false"){
 //       	$(".JS_btn_view").bind("click",function () {
 //       	initContentByFormat("");
//			var isValidate = validateFrom();
//			if(!isValidate){
//				return;
//			}
//            else {
//                initContentByFormat("&nbsp;");
//            	setFeatureHiddenDiv();
//                destoryDialog(previewDialog);
//                previewDialog = backstage.dialog({
//	                title: "预览效果",
//	                iframe: true,
//	                url: "previewProdFeature.do",  //内容：支持jQuery对象与HTML文本
//	                width: 1200,  //宽度
//	                height: 500,  //高度
//	                padding: 5,  //内边距
//	                className: "pf-dialog-view",
//	                callback: function () {
//	                    //关闭时执行
//	                }
//	            });
//                
//                $("<div class='dialog-close' style='margin-right:600px;'>×</div>").insertBefore($(".pf-dialog-view .dialog-close"));
//                $(".pf-dialog-view").on('click', '.dialog-close', function() {
//                        destoryDialog(previewDialog);
//                });

//            }

 //         });
 //       }
	if($("#editFlag").val() != "false"){	
        //添加图片
        $document.on("click", ".JS_main_add_picture", function () {
			$("#divIndex").val("");        	
            var $this = $(this);
            var $content = $(".pf-insert-picture").clone();
            $content.find("#divInsetr4").attr("data-batch-type","true");
            imageOperate2 = backstage.dialog({
                title: "插入图片",
                $content: $content,
                width: 820,
                height: 510,
                padding: 5
            });
             multipleList();
        });
        
        /* 编辑图片 */
        $document.on("click", ".JS_movable_edit", function () {
            var $this = $(this);
            var $movable = $this.parents(".pf-movable");
            var divIndex=$movable.attr("divIndex");
            if(!divIndex){
               divIndex=$this.attr("divIndex");
               $movable.attr("divIndex",divIndex);
             }
            $("#divIndex").val(divIndex);
            var $content = $(".pf-insert-picture").clone();
            var $btn1=$content.find("#btn1");
            var $btn2=$content.find("#btn2");
            var $btn3=$content.find("#btn3");
            var $btn4=$content.find("#btn4");
            var $divInsetr1=$content.find("#divInsetr1");
            var $divInsetr2=$content.find("#divInsetr2");
            var $divInsetr3=$content.find("#divInsetr3");
            var $divInsetr4=$content.find("#divInsetr4");
            $btn1.attr("class", "btn");//初始化
            $divInsetr1.attr("class", "pf-insert-pane");
            var $parentDiv=$("div[divIndex='"+divIndex+"']");
            var picTemplate = $parentDiv.attr("data-class");
            if(picTemplate=="pf-movable-picture-one"){
				var img11=$parentDiv.find("img[name='img11']");
				var src=img11.attr("src");
				$btn1.attr("class", "btn btn-primary");
				$content.find("#imgInsert1").attr("src", src);
				$divInsetr1.attr("class", "pf-insert-pane active");
			}
			if(picTemplate=="pf-movable-picture-one-with-title"){
				var img12=$parentDiv.find("img[name='img12']");
				var src=img12.attr("src");
				$btn1.attr("class", "btn btn-primary");
				$content.find("#imgInsert1").attr("src", src);
				$divInsetr1.attr("class", "pf-insert-pane active");
				var $ptext=$parentDiv.find("p");
				$content.find("#pictureInfo").val($ptext.html());
			}
			if(picTemplate=="pf-movable-picture-two"){
				$btn2.attr("class", "btn btn-primary");
				$divInsetr2.attr("class", "pf-insert-pane active");
				var img21=$parentDiv.find("img[name='img21']");
				var img22=$parentDiv.find("img[name='img22']");
				$content.find("#imgInsert21").attr("src", img21.attr("src"));
				$content.find("#imgInsert22").attr("src", img22.attr("src"));
			}
			if(picTemplate=="pf-movable-picture-three"){
				$btn3.attr("class", "btn btn-primary");
				$divInsetr3.attr("class", "pf-insert-pane active");
				var img31=$parentDiv.find("img[name='img31']");
				var img32=$parentDiv.find("img[name='img32']");
				var img33=$parentDiv.find("img[name='img33']");
				$content.find("#imgInsert31").attr("src", img31.attr("src"));
				$content.find("#imgInsert32").attr("src", img32.attr("src"));
				$content.find("#imgInsert33").attr("src", img33.attr("src"));
			}
			if(picTemplate=="pf-movable-picture-custom"){
				var img41=$parentDiv.find("img[name='img41']");
				var src=img41.attr("src");
				$btn4.attr("class", "btn btn-primary");
				$content.find("#imgInsert41").attr("src", src);
				$divInsetr4.attr("class", "pf-insert-pane active");
				
			}
			imageOperate3 = backstage.dialog({
                title: "编辑图片",
                $content: $content,
                width: 820,
                height: 510,
                padding: 5
            });
             multipleNone();
        });

        //大标题
        $document.on("click", ".JS_main_add_big_title", function () {
            var $bigTitle = $template.find(".pf-movable-big-title").clone();
            addModule($bigTitle);
        });

        //小标题
        $document.on("click", ".JS_main_add_small_title", function () {
            var $smallTitle = $template.find(".pf-movable-small-title").clone();
            addModule($smallTitle);
        });

        //正文
        $document.on("click", ".JS_main_add_text", function () {
            var $text = $template.find(".pf-movable-text").clone();
             addModule($text);
            window.refreshPaste();
        });

        //删除模块
        $document.on("click", ".JS_movable_del", function () {
            var $this = $(this);
            var $movable = $this.parents(".pf-movable");
            $movable.slideUp(200, function () {
                $movable.remove();
            });

        });
		/*选择图片*/
	    $document.on("click", ".pf-insert-picture .picture", function () {
	        var $this=$(this);
            choosePicture($this,true);
	    });
         function choosePicture($this,single){
            $currentPicture = $this;
            $currentPictureTemplate=$this;
            /*var url="/pic/photo/photo/imgPlugIn.do?relationId="+$("#productId").val()+"&relationType=1";*///&imgLimitType=LIMIT_3_2_3L
             var url="/photo-back/photo/photo/imgPlugIn.do?relationId="+$("#productId").val()+"&relationAuthor="+$("#userName").val()+"&relationType=17";
             var  nowDate = new Date().Format("yyyyMMdd");
             url+="&photoSource=vst&relationTime="+nowDate;
            var dataId=$this.attr("data-id");
            if(dataId=="11"){
                url+="&imgLimitSize=LIMIT_1080_432";
            }if(dataId=="21" || dataId=="22"){
                url+="&imgLimitType=LIMIT_3_2_3L&imgLimitSize=LIMIT_530_353";
            }if(dataId=="31" || dataId=="32" || dataId=="33"){
                url+="&imgLimitType=LIMIT_3_2_3L&imgLimitSize=LIMIT_347_231";
            }if(dataId=="41"){
                url+="&imgLimitSize=LIMIT_1080_";
            }
            if(single){
                url+="&imgLimitNum=single";
            }
            imageOperate = backstage.dialog({
                title: "选择或上传图片",
                iframe: true,
                url: url,
                width: 900,
                height: 610
            });

        }
	    $document.on("click",".JS_picture_btn_ok",function(){
			savePic();
		});
		
	}
		//插入图片到主体
	    function savePic() {
			$(".dialog-content .pf-insert-picture").find("div[flag='picTmp']").each(function(){
				var $this=$(this);
				var divIndex=$("#divIndex").val();
				if($this.attr("class")=="pf-insert-pane active"){
					var $checkPicture = checkPicture($this);
					if($checkPicture){
						//调用父页面的图片模板
						if($this.attr("data-template")=="pf-movable-picture-one"){
							var pictureInfo=$this.find("#pictureInfo").val();
							if(pictureInfo!=null && pictureInfo!=""){
								var pictureOneTitleTmp = $(".template>.pf-movable-picture-one-with-title").clone();
								var pictureOneTitle=pictureOneTitleTmp;
								pictureOneTitle.find("img[name='img12']").attr("src",getUrlBySize($this.find("img").attr("src"),"1080_432"));
								pictureOneTitle.find("p").html($this.find("#pictureInfo").val());
								
								if(divIndex!=null && divIndex!=""){
									var $parentDiv=$("div[divIndex='"+divIndex+"']");
									pictureOneTitle.find("a.JS_movable_edit").attr("divIndex",divIndex);
									var flag=$parentDiv.replaceWith(pictureOneTitle);
									if(flag){
										imageOperate3.destroy();
									}
								}else{
                                    addModule(pictureOneTitle);
									imageOperate2.destroy();
									
								}
								
							}else{
								var pictureOneTmp = $(".template>.pf-movable-picture-one" ).clone();
								var pictureOne = pictureOneTmp;
								pictureOne.find("img[name='img11']").attr("src",getUrlBySize($this.find("img").attr("src"),"1080_432"));
								if(divIndex!=null && divIndex!=""){
									var $parentDiv=$("div[divIndex='"+divIndex+"']");
									pictureOne.find("a.JS_movable_edit").attr("divIndex",divIndex);
									var flag=$parentDiv.replaceWith(pictureOne);
									if(flag){
										imageOperate3.destroy();
									}
								}else{
                                    addModule(pictureOne);
									imageOperate2.destroy();
								}
								
							}
						}else if($this.attr("data-template")=="pf-movable-picture-two"){
							var pictureTwoTmp = $(".template>.pf-movable-picture-two").clone();
							var pictureTwo=pictureTwoTmp;
							var imgArray=$this.find("img");
							pictureTwo.find("img[name='img21']").attr("src",imgArray[0].src);
							pictureTwo.find("img[name='img22']").attr("src",imgArray[1].src);
							if(divIndex!=null && divIndex!=""){
								var $parentDiv=$("div[divIndex='"+divIndex+"']");
								pictureTwo.find("a.JS_movable_edit").attr("divIndex",divIndex);
								var flag=$parentDiv.replaceWith(pictureTwo);
								if(flag){
									imageOperate3.destroy();
								}
							}else{
                                addModule(pictureTwo);
								imageOperate2.destroy();
							}
							
							
						}else if($this.attr("data-template")=="pf-movable-picture-three"){
							var pictureThreeTmp = $(".template>.pf-movable-picture-three").clone();
							var pictureThree=pictureThreeTmp;
							var imgArray=$this.find("img");
							pictureThree.find("img[name='img31']").attr("src",imgArray[0].src);
							pictureThree.find("img[name='img32']").attr("src",imgArray[1].src);
							pictureThree.find("img[name='img33']").attr("src",imgArray[2].src);
							if(divIndex!=null && divIndex!=""){
								var $parentDiv=$("div[divIndex='"+divIndex+"']");
								pictureThree.find("a.JS_movable_edit").attr("divIndex",divIndex);
								var flag=$parentDiv.replaceWith(pictureThree);
								if(flag){
									imageOperate3.destroy();
								}
							}else{
                                addModule(pictureThree);
								imageOperate2.destroy();
							}
						}else if($this.attr("data-template")=="pf-movable-picture-custom"){

						var batchType = $this.attr("data-batch-type");
                        var $imgArray = null;
                        if (batchType == "true") {
                            $imgArray = $this.find('.multiple-picture-list').find('img');
                        } else {
                            $imgArray = $this.find('.multiple-picture').find('img');
                        }

                        $imgArray.each(function() {
                            var pictureCustomTmp = $(".template>.pf-movable-picture-custom").clone();
                            var pictureCustom = pictureCustomTmp;
                            pictureCustom.find("img[name='img41']").attr("src", $(this).attr("src"));
                            if (divIndex != null && divIndex != "") {
                                var $parentDiv = $("div[divIndex='" + divIndex + "']");
                                pictureCustom.find("a.JS_movable_edit").attr("divIndex", divIndex);
                                var flag = $parentDiv.replaceWith(pictureCustom);
                                if (flag) {
                                    imageOperate3.destroy();
                                }
                            } else {
                                addModule(pictureCustom);
                                imageOperate2.destroy();
                            }

                        });



						}
					}else{
						alert("请选择图片");
					}
				}
				
			});
	    }
	    
    function checkPicture(template) {
        var res = true;
        if (template.attr("data-batch-type") == "true") {
            if (template.find(".multiple-picture-list").find('img').length<1) {
                res = false;
            }

        } else {
            template.find("img").each(function() {
                if ($(this).attr("src") == null || $(this).attr("src") == "") {
                    res = false;
                }
            });
        }
        return res;
    }
    
      //复制产品富文本                            
    $document.on("click", ".JS_btn_copy_richText", function() {
        destoryDialog(copyFeatureDialog);
        var $content = $("<div style='margin-top:50px; margin-left:100px;'><label><p>产品ID：</p></label><input type='text' value='' id='copyRichProductId' maxlength='11' placeholder='请输入要复制的产品ID'></div><div class='pf-insert-pane-btn-group' style='margin-left:150px;margin-top:30px;width:450px;''><a class='btn JS_copy_btn_ok3'>确定</a><a class='btn JS_copy_btn_cancel' href='javascript:'>取消</a></div>");
        copyFeatureDialog = backstage.dialog({
            width: 450,
            height: 180,
            title: "复制产品富文本",
            $content: $content,
            padding: 10
        });

    });
    
    //复制产品富文本验证事件
    $document.on("click", ".JS_copy_btn_ok3", function() {
        var copyRichProductId = $("#copyRichProductId").val();
        if (!copyRichProductId || copyRichProductId == "") {
            backstage.alert({
                title: "系统提示",
                content: "请输入产品ID"
            });
            return;
        }
        var chars = /^[0-9]*[1-9][0-9]*$/; //验证正整数  
        if (!chars.test(copyRichProductId)) {
            backstage.alert({
                title: "系统提示",
                content: "产品ID请输入正整数"
            });
            return;
        }
        if(copyRichProductId==$("input[name='productId']").val()){
             backstage.alert({
                title: "系统提示",
                content: "不能复制自己的产品富文本"
            });
            return;
        }

        backstage.confirm({
            width: 450,
            height: 180,
            title: "标题",
            content: "<p><b>复制产品富文本后，原有的产品富文本将会被覆盖。请确认</b></p>",
            determineCallback: function() {
                //确定时执行
                copyProdRichText(copyRichProductId);
            },
            cancelCallback: function() {
                //取消与关闭时执行
                destoryDialog(copyFeatureDialog);
            }
        });

    });
    
        //复制产品富文本ajax请求
    function copyProdRichText(copyProductId) {
    	destoryDialog(copyFeatureDialog);
        $.ajax({
            url: "/vst_admin/packageTour/prod/product/copyProdRichText.do",
            type: "post",
            dataType: 'json',
            data: {
                oldProductId: $("input[name=\"productId\"]").val(),
                newProductId: copyProductId,
            },
            success: function(result) {
                if (result.code == "success") {
                	if(dataObjRich[0]!=null){
		        		window.frames[0].frames.frameElement.contentDocument.body.innerHTML=result.message;
	                	}
                    backstage.alert({
                        content: "<i class='pf-icon pf-icon-big pf-icon-success'></i>&nbsp;复制成功，请进一步保存提交",
                    });
                } else {
                    backstage.alert({
                        title: "系统提示",
                        content: result.message
                    });
                }
            },
            error: function() {
                backstage.alert({
                    title: "系统提示",
                    content: '网络服务异常, 请稍后重试'
                });
               
            }
        });
    }
    
     //复制产品特色                               
    $document.on("click", ".JS_btn_copy", function() {
        destoryDialog(copyFeatureDialog);
        var $content = $("<div style='margin-top:50px; margin-left:100px;'><label><p>产品ID：</p></label><input type='text' value='' id='copyProductId' maxlength='11' placeholder='请输入要复制的产品ID'></div><div class='pf-insert-pane-btn-group' style='margin-left:150px;margin-top:30px;width:450px;''><a class='btn JS_copy_btn_ok'>确定</a><a class='btn JS_copy_btn_cancel' href='javascript:'>取消</a></div>");
        copyFeatureDialog = backstage.dialog({
            width: 450,
            height: 180,
            title: "复制产品特色",
            $content: $content,
            padding: 10
        });

    });

    
 
    //复制产品特色验证事件
    $document.on("click", ".JS_copy_btn_ok", function() {
        var copyProductId = $("#copyProductId").val();
        if (!copyProductId || copyProductId == "") {
            backstage.alert({
                title: "系统提示",
                content: "请输入产品ID"
            });
            return;
        }
        var chars = /^[0-9]*[1-9][0-9]*$/; //验证正整数  
        if (!chars.test(copyProductId)) {
            backstage.alert({
                title: "系统提示",
                content: "产品ID请输入正整数"
            });
            return;
        }
        if(copyProductId==$("input[name='productId']").val()){
             backstage.alert({
                title: "系统提示",
                content: "不能复制自己的产品特色"
            });
            return;
        }

        backstage.confirm({
            width: 450,
            height: 180,
            title: "标题",
            content: "<p><b>复制产品特色后，原有的产品特色将会被覆盖。请确认</b></p>",
            determineCallback: function() {
                //确定时执行
                copyProdFeature(copyProductId);
            },
            cancelCallback: function() {
                //取消与关闭时执行
                destoryDialog( copyFeatureDialog);
            }
        });

    });
    
    

    /**
     * 添加模块
     * $module: 模块jQuery对象
     */
    function addModule($module) {
        var $productInsertPositionChecked = $("[name=product-insert-position]:checked");
        if ($productInsertPositionChecked.length > 0) {
            var $productInsertPositionCheckedFirst = $productInsertPositionChecked.first();
            var $movable = $productInsertPositionCheckedFirst.parents(".pf-movable");
            $movable.after($module);
        } else {
            $main.append($module);
        }
        if ($module.attr("featproptype") == "IMG") {
            var maxIndex = Number($("#maxIndex").val()) + 1;
            $("#maxIndex").val(maxIndex)
            $module.attr("divIndex", maxIndex);
        }
    }

    //单选事件
    $document.on("click", "[name=product-insert-position]", function() {
        var $this = $(this);
        var isChecked = $this.is("[data-checked=checked]");
        $("[name=product-insert-position]").attr("data-checked", "");
        if (isChecked) {
            $this.attr("checked", false);
        }
        else{
             $this.attr("data-checked", "checked");
        }
       
        
    });
      //插入图片-自定义图片-删除
    $document.on("click", ".multiple-picture-list .upload-item-delete", function() {
        var $this = $(this);
        var $uploadItem = $this.parents(".upload-item");
        var $multiplePictureList = $this.parents(".multiple-picture-list");
        $uploadItem.remove();
        setImgCount($multiplePictureList);
    });
    //添加图片 多张图
    $document.on("click", ".multiple-picture-list .JS_multiple_picture_add", function() {
        var $this = $(this);
        choosePicture($this,false);
    });
    //添加图片 单张图
    $document.on("click", ".multiple-picture-list .upload-item-mask", function() {
        var $this = $(this);
        choosePicture($this,true);
        var $multiplePictureList = $this.parents(".multiple-picture-list");
        $multiplePictureList.attr("replaceImgs", "true");
        var $imgs = $multiplePictureList.find('img');
        $imgs.each(function() {
            $imgs.removeClass('replaceImg')
        });
        $this.addClass('replaceImg');

    });

});


    function photoCallback(photoJson, extJson) {
        var picTemplate = $currentPictureTemplate.attr("data-id");
        //判断是新增自定义图片,加入批量处理
        var $parent = $currentPictureTemplate.parents("#divInsetr4");
        var $multiplePictureList = $parent.find('.multiple-picture-list');
        var replaceImgs = $multiplePictureList.attr("replaceImgs");
        var batchType = $parent.attr("data-batch-type");
        //添加批量图片
        if (batchType == "true" && photoJson.photos && replaceImgs != "true") {
            for (var i in photoJson.photos) {
                var url = "http://pic.lvmama.com" + photoJson.photos[i].photoUpdateUrl;
                var $li = $("#divInsetrBatch4").find(".upload-item").clone();
                $li.find("img").attr("src", url);
                var name=url.substring(url.lastIndexOf("/")+1,url.length);
                $li.find(".imgName").html(name);
                if (isNotDuplicate($multiplePictureList, url)) {
                    $li.insertBefore($multiplePictureList.find('.picture_add_end'));
                }
            }
        }
        //更换指定图片
        if (batchType == "true" && replaceImgs == "true") {
            var url = getAlongImg(photoJson);
            if(isNotDuplicate($multiplePictureList,url)){
            var $replaceImg = $multiplePictureList.find('.replaceImg');
            $replaceImg.attr("src", url);
            $replaceImg.removeClass('replaceImg');
            $multiplePictureList.attr("replaceImgs", "false");
        }
        }
        if (batchType == "true") {
            setImgCount($multiplePictureList);
        }
        if (batchType != "true") {
            var $img = $currentPictureTemplate.find("img");
            var url = getAlongImg(photoJson);
            $img.attr("src", url)
        }

        imageOperate.destroy();
    }

    //图片去重
    function isNotDuplicate($div,url){
        var $imgs=$div.find('img');
        var result=true;
        $imgs.each(function() {
            if($(this).attr("src")==url){
                result=false;
                return;
            }
        });
        return result;

    } 

    //得到单张图片
    function getAlongImg(photoJson) {
        var imgUrl = "";
        if (photoJson.photos) {
            imgUrl = "http://pic.lvmama.com" + photoJson.photos[0].photoUpdateUrl;
        }
        if (photoJson.photo) {
            imgUrl = "http://pic.lvmama.com" + photoJson.photo.photoUpdateUrl;
        }
        return imgUrl;

    }
    //设置图片数量
    function setImgCount($div) {
        var $count = $div.find('.multiple-picture-list-info span');
        var newCount = $div.find('img').length;
        $count.html(newCount+"张图片。");
    }

    //为一张图模式添加图片大小限制
    function getUrlBySize(url, size) {
        var returnResult = url;
        if (url.indexOf("1080_432") < 0 && url.indexOf("530_353") < 0 && url.indexOf("347_231") < 0) {
            if (String(url).length > 4) {
                returnResult = url.substring(0, url.length - 4) + "_" + size + ".jpg";

            }
        }
        return returnResult;
    }



     //初始化换行 空格等特殊字符
    function initContentByFormat(space) {

        $(".pf-text-edit").each(function() {
            var $this = $(this);
            var text = getPlainTxtWithWrap($this);
            $this.next(".pf-text-edit-hidden").val(text).change();
            if (space != "") {
                text = text.replace(/[\n\r]/g, '<br/>');
                $this.next(".pf-text-edit-hidden").val(text);
            }
        });


    }
    //复制产品特色ajax请求
    function copyProdFeature(copyProductId) {
    	var copyType = $('#type input[name="copyType"]:checked ').val();
    	destoryDialog(copyFeatureDialog);
        $.ajax({
            url: "/vst_admin/packageTour/prod/product/copyProdFeature.do",
            type: "post",
            dataType: 'json',
            data: {
                oldProductId: $("input[name=\"productId\"]").val(),
                newProductId: copyProductId,
                copyType: copyType
            },
            success: function(result) {
                if (result.code == "success") {
                    backstage.alert({
                        content: "<i class='pf-icon pf-icon-big pf-icon-success'></i>&nbsp;保存成功",
                        callback: function() {
                            window.location.reload();
                        }
                    });
                } else {
                    backstage.alert({
                        title: "系统提示",
                        content: result.message
                    });
                }
                
            },
            error: function() {
                backstage.alert({
                    title: "系统提示",
                    content: '网络服务异常, 请稍后重试'
                });
               
            }
        });


    }

       function destoryDialog(dialog) {
           if (dialog) {
               dialog.destroy();
           }
       }
       //自定义图片-显示上传
       function multipleNone() {
           $(".multiple-picture-list").hide();
           $(".multiple-picture").show();
       }

       //自定义图片-显示列表
       function multipleList() {
           $(".multiple-picture-list").show();
           $(".multiple-picture").hide();
       }
    Date.prototype.Format = function (fmt) { //author: fangxiang 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
</script>
</body>
</html>
