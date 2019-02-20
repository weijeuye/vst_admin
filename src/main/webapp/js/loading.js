//加载开始时显示loading效果
function startLoading(message)
{	
	var alertFram = document.createElement("DIV");//产生一个提示框
	var height="50px";
    alertFram.id="alertFram";
    alertFram.style.position = "fixed";
    alertFram.style.width = "200px";
    alertFram.style.height = height;
    alertFram.style.left = "45%";
    alertFram.style.top = "30%";
    alertFram.style.background = "#fff";
    alertFram.style.textAlign = "center";
    alertFram.style.lineHeight = "57px";
    alertFram.style.zIndex = "10001";
	
	strHtml =" <div style=\"width:100%; border:#58a3cb solid 1px; text-align:center;padding-top:10px; background:#4D90FE;\">";
    strHtml+=" <img src=\"http://pic.lvmama.com/img/common/loading.gif\"><br>";
    if (typeof(message)=="undefined"){
        strHtml+="页面加载中，请等待...";
    } 
    else{
        strHtml+=message;
    }
    strHtml+=" </div>";
	
    //呈现loading效果
	alertFram.innerHTML=strHtml;
    document.body.appendChild(alertFram);
}

//加载结束时移除loading效果
function completeLoading() {
	var alertFram= document.getElementById('alertFram');
	document.body.removeChild(alertFram);
}
