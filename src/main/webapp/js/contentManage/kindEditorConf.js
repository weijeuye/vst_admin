if(!Date.prototype.Format) {
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
}


(function ($, K) {
    var editorCmd, a_uploadImg;

    function Factory() {
        return new lvmamaEditor();
    }
    
    function lvmamaEditor() {
        this.initialize();
        Factory.uploadImageCallback = this.uploadImageCallback;
        Factory.editorCreate = this.editorCreate;
        Factory.insertDetailsCallback = this.insertDetailsCallback;
    }

    lvmamaEditor.prototype = {
        initialize: function () {
            var that = this;
            // 一级标题
            K.plugin("joyuFirstLevelTitle", function (k) {
                var editor = this, name = "joyuFirstLevelTitle";
                var clickCallBack = function () {
                    editor.exec("formatblock", "<h1>");
                }
                editor.clickToolbar(name, clickCallBack);
            });
            // 二级标题
            K.plugin("joyuSecondLevelTitle", function (k) {
                var editor = this, name = "joyuSecondLevelTitle";
                var clickCallBack = function () {
                    editor.exec("formatblock", "<h3>");
                }
                editor.clickToolbar(name, clickCallBack);
            });
            // 正文
            K.plugin("joyuMainContent", function (k) {
                var editor = this, name = "joyuMainContent";
                var clickCallBack = function () {
                    editor.exec("formatblock", "<p>");
                }
                editor.clickToolbar(name, clickCallBack);
            });
            // 内容信息
            K.plugin("joyuDestination", function (k) {
                var editor = this, name = "joyuDestination";
                editorCmd = this;
                var html = [
                    '<div>',
                    '<div class="contontHead">目的地名称:<input type="text" style="width:200px;"/>',
                    '<a class="btn btn-mini" onclick="searchOperate()">搜索</a><a class="btn btn-mini ">上一页</a><span><i>1</i>/<i>10</i></span><a class="btn btn-mini ">下一页</a>',
                    '</div>',
                    '<div>',
                    '<table class="contentTable">',
                    '</table>',
                    '</div>',
                    '</div>'
                ].join('');
                var clickCallBack = function () {
                    that.insertDetailsClick();
                    editorCmd = editor;
                }
                editor.clickToolbar(name, clickCallBack);
            });
            // 图片
            K.plugin("joyuImage", function (k) {
                var editor = this, name = "joyuImage";
                editorCmd = this;
                var html = [
                    '<div class="joyu-image-box">',
                    '<div class="joyu-image-box-head">',
                    '<div class="joyu-image-box-left">',
                    '<ul>',
                    '<li>图片数量:</li>',
                    '<li><input type="radio" name="raImageCount" id="raImageCount1" value="1" checked="checked"/><label for="raImageCount1">一张</label></li>',
                    '<li><input type="radio" name="raImageCount" id="raImageCount2" value="2"/><label for="raImageCount2">两张</label></li>',
                    '<li><input type="radio" name="raImageCount" id="raImageCount3" value="3"/><label for="raImageCount3">三张</label></li>',
                    '<li><input type="radio" name="raImageCount" id="raImageCount4" value="4"/><label for="raImageCount4">四张</label></li>',
                    '</ul>',
                    '</div>',
                    '<div class="joyu-image-box-right" style="display:none">',
                    '<ul>',
                    '<li>图片布局:</li>',
                    '<li><input type="radio" name="raImageLayout" id="raImageLayout1" value="1" checked="checked"/><label for="raImageLayout1">横向</label></li>',
                    '<li><input type="radio" name="raImageLayout" id="raImageLayout2" value="2"/><label for="raImageLayout2">纵向</label></li>',
                    '<li><input type="radio" name="raImageLayout" id="raImageLayout3" value="3"/><label for="raImageLayout3">交错</label></li>',
                    '</ul>',
                    '</div>',
                    '</div>',
                    '<div class="joyu-image-box-main">',
                    '</div>',
                    '<div style="clear:both"></div>',
                    '</div>'
                ].join('');
                var clickCallBack = function () {
                    editor.createDialog({
                        name: "about",
                        width: 500,
                        title: "插入图片",
                        body: html,
                        shadowMode: true,
                        showMask: true,
                        yesBtn: {
                            name: "确定",
                            click: function (e) {
                                that.commitImage(editor);
                            }
                        }
                    });
                    $("div.joyu-image-box-head :radio").bind("click", function () {
                        that.initImagePlaceholder();
                    });
                    that.initImagePlaceholder();
                    editorCmd = editor;
                }
                editor.clickToolbar(name, clickCallBack);
            });
        },
        //创建图片布局
        initImagePlaceholder: function () {
            var that = this;
            var imgselect = '<p><a href="javascript:;">本地上传</a></p><p><a href="javascript:;">图库选图</a></p>';
            var imageCount = $(":radio[name='raImageCount']:checked").val(), html = [];
            var placeType = $(":radio[name='raImageLayout']:checked").val(); //1:横向 2: 纵向 3: 交错
            switch (imageCount) {
                case "1":
                    html.push('<div class="joyu-image-content" style="width:458px; height:100px;"><div class="joyu-imageSelect-box" style="top:30px;left:204px">' + imgselect + '</div></div>');
                    break;
                case "2":
                    if (placeType === "1") {
                        for (var i = 1; i <= 2; i++) {
                            html.push('<div class="joyu-image-content" style="width:218px; height:100px;"><div class="joyu-imageSelect-box" style="top:30px;left:84px">' + imgselect + '</div></div>');
                        }
                    } else if (placeType === "2") {
                        for (var i = 1; i <= 2; i++) {
                            html.push('<div class="joyu-image-content" style="width:458px; height:100px;"><div class="joyu-imageSelect-box" style="top:30px;left:204px">' + imgselect + '</div></div>');
                        }
                    }
                    break;
                case "3":
                    if (placeType === "1") {
                        for (var i = 1; i <= 3; i++) {
                            html.push('<div class="joyu-image-content" style="width:138px; height:70px;"><div class="joyu-imageSelect-box" style="top:15px;left:44px">' + imgselect + '</div></div>');
                        }
                    } else if (placeType === "2") {
                        for (var i = 1; i <= 3; i++) {
                            html.push('<div class="joyu-image-content" style="width:458px; height:100px;"><div class="joyu-imageSelect-box" style="top:30px;left:204px">' + imgselect + '</div></div>');
                        }
                    } else {
                        html.push('<div class="joyu-image-content" style="width:458px; height:100px;"><div class="joyu-imageSelect-box" style="top:30px;left:204px">' + imgselect + '</div></div>');
                        for (var i = 1; i <= 2; i++)
                            html.push('<div class="joyu-image-content" style="width:218px; height:100px;"><div class="joyu-imageSelect-box" style="top:30px;left:84px">' + imgselect + '</div></div>');
                    }
                    break;
                case "4":
                    if (placeType === "1") {
                        for (var i = 1; i <= 4; i++) {
                            html.push('<div class="joyu-image-content" style="width:98px; height:50px;"><div class="joyu-imageSelect-box" style="top:5px;left:24px">' + imgselect + '</div></div>');
                        }
                    } else if (placeType === "2") {
                        for (var i = 1; i <= 4; i++) {
                            html.push('<div class="joyu-image-content" style="width:458px; height:100px;"><div class="joyu-imageSelect-box" style="top:30px;left:204px">' + imgselect + '</div></div>');
                        }
                    } else {
                        for (var i = 1; i <= 4; i++) {
                            html.push('<div class="joyu-image-content" style="width:218px; height:100px;"><div class="joyu-imageSelect-box" style="top:30px;left:84px">' + imgselect + '</div></div>');
                        }
                    }
                    break;
            }
            html = html.join('');
            $("div.joyu-image-box-main").html(html);
            $("div.joyu-image-box-main a").bind("click", function (e) { that.uploadImageClick(e); });
        },
        //点击选取图片A标签时触发
        uploadImageClick: function (e) {
            var that = this;
            var username=$("#userName").val();
            var cateGoryId=$("#categoryId",window.parent.document).val();
            var productId=$("#productId",window.parent.document).val();
            a_uploadImg = e.target || window.event.srcElement;
            /*var url = "/pic/photo/photo/imgPlugIn.do";*/
            var url = "/photo-back/photo/photo/imgPlugIn.do";
    		url += "?imgLimitType=LIMIT_0_0_3L";
    		url+="&relationAuthor="+username+"&relationTime="+new Date().Format("yyyyMMdd")+"&photoSource=vst&relationType="+cateGoryId+"&relationId="+productId;
    		
    		comPhotoAddDialog = new xDialog(url,{},{title:"上传图片",iframe:true,width:920,height:750,zIndex:3335});
            
        },
        //选择图片后的回调函数
        uploadImageCallback: function (url) {
            url = url;//选择图片后改变这个url
            var html = '<img style="width:100%;height:100%" alt="" src="' + url + '"/>';
            var box = $(a_uploadImg).parentsUntil("div.joyu-image-content").parent(".joyu-image-content");
            box.find("img").remove();
	        box.append(html);
            comPhotoAddDialog.close();
        },
        //插入图片
        commitImage: function (editor) {
            var that = this;
            var imageCount = $(":radio[name='raImageCount']:checked").val(), html = [];
            var placeType = $(":radio[name='raImageLayout']:checked").val(); //1:横向 2: 纵向 3: 交错
            var imgs = $(".joyu-image-box-main img");
            if (imgs.size() < imageCount) {
                alert("请先选择" + imageCount + "张图片");
                return;
            }
            switch (imageCount) {
                case "1":
                    html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;"><img width="90%" alt="" data-ke-src="' + imgs[0].src + '" src="' + imgs[0].src + '"/></span></p>');
                    break;
                case "2":
                    if (placeType === "1") {
                        html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;">');
                        for (var i = 0; i < 2; i++) {
                            html.push('<img width="45%" alt="" data-ke-src="' + imgs[i].src + '" src="' + imgs[i].src + '"/>');
                        }
                        html.push('</span></p>');
                    } else if (placeType === "2") {
                        for (var i = 0; i < 2; i++) {
                            html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;"><img width="90%" alt="" data-ke-src="' + imgs[i].src + '" src="' + imgs[i].src + '"/></span></p>');
                        }
                    }
                    break;
                case "3":
                    if (placeType === "1") {
                        html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;">');
                        for (var i = 0; i < 3; i++) {
                            html.push('<img width="30%" alt="" data-ke-src="' + imgs[i].src + '" src="' + imgs[i].src + '"/>');
                        }
                        html.push('</span></p>');
                    } else if (placeType === "2") {
                        html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;">');
                        for (var i = 0; i < 3; i++) {
                            html.push('<img width="90%" alt="" data-ke-src="' + imgs[i].src + '" src="' + imgs[i].src + '"/>');
                        }
                        html.push('</span></p>');
                    } else {
                        html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;"><img width="90%" height="100%" alt="" data-ke-src="' + imgs[0].src + '" src="' + imgs[0].src + '"/></span></p>');
                        html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;">');
                        for (var i = 1; i <= 2; i++) {
                            html.push('<img width="45%" alt="" data-ke-src="' + imgs[i].src + '" src="' + imgs[i].src + '"/>');
                        }
                        html.push('</span></p>');
                    }
                    break;
                case "4":
                    if (placeType === "1") {
                        html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;">');
                        for (var i = 0; i < 4; i++) {
                            html.push('<img width="25%" alt="" data-ke-src="' + imgs[i].src + '" src="' + imgs[i].src + '">');
                        }
                        html.push('</span></p>');
                    } else if (placeType === "2") {
                        html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;">');
                        for (var i = 0; i < 4; i++) {
                            html.push('<img width="90%" alt="" data-ke-src="' + imgs[i].src + '" src="' + imgs[i].src + '">');
                        }
                        html.push('</span></p>');
                    } else {
                        var index = 0;
                        do {
                            html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;">');
                            for (var i = 0; i < 2; i++) {
                                index = index == 0 ? 0 : 2;
                                html.push('<img width="45%" alt="" data-ke-src="' + imgs[i + index].src + '" src="' + imgs[i + index].src + '">');
                            }
                            html.push('</span></p>');
                            index++;
                        } while (index <= 1);
                    }
                    break;
            }
            html = html.join('');
            editorCmd.insertHtml(html);
            editor.hideDialog();
        },
        //点击插入内容按钮触发的事件
        insertDetailsClick: function () {
        	comDestContentAddDialog = new xDialog("/vst_admin/biz/dest/showDestList.do",{},{title:"插入内容",iframe:true,width:840,height:800,zIndex:3335});
        },
        //插入内容回调事件(将返回数据拼接为html)
        insertDetailsCallback: function (title, desc, imgUrlArray) {
            var html = [];
            html.push('<h1><p align="center">' + title + '</p></h1>');
            html.push('<p align="center">' + desc + '</p>');
            for (var i = 0; i < imgUrlArray.length; i++)
                html.push('<p align="center"><span style="font-family:SimSun;font-size:16px;color:#000000;"><img width="90%" alt="" data-ke-src="' + imgUrlArray[i] + '" src="' + imgUrlArray[i] + '"></span></p>');
            html = html.join('');
            editorCmd.insertHtml(html);
        },
        editorCreate: function (attrName,attrVal) {
            var editor = K.create('['+attrName+'='+attrVal+']', {
                resizeType: 1,
                width: '800px',
                filterMode: true,
                items: [
                {
                    groupTitle: "字号"
                },
                "joyuFirstLevelTitle",
                "joyuSecondLevelTitle",
                "joyuMainContent",
                {
                    groupTitle: "文本编辑"
                },
                "justifyleft",
                "justifycenter",
                "justifyright",
                "bold",
                "forecolor",
                "link",
                "unlink",
                {
                    groupTitle: "插入"
                },
                "table",
                "joyuDestination",
                "insertorderedlist",
                "joyuImage"
                ]
            });
            return editor;
        }
    };
    Factory();
    window.lvmamaEditor = Factory;
}(jQuery, KindEditor));