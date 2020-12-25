# Xây dựng mô hình Kubernetes (K8s) sử dụng High Availability trên Google Cloud  

Trong thế giới công nghiệp số hiện đại hiện nay, nhu cầu triển khai các cơ sở hạ tầng mạng ở nhiều nơi là rất cần thiết. Các dịch vụ và ứng dụng của chúng ta sẽ nằm ở nhiều nơi khác nhau, trên nhiều thiết bị khác nhau, có thể là dịch vụ của mình hoặc đi thuê từ các nơi khác từ Google, Azure hay Oracle, ... Điều đó đặt ra vấn đề cần có một nền tảng để duy trì và quản lý các ứng dụng như vậy để chạy trên cloud vì bây giờ ai cũng biết cloud được coi là giải pháp tối ưu nhất cho việc xây dựng một hệ thống thông minh trên Internet.  

K8s chính là một nền tảng được tạo ra có thể đáp ứng được những nhu cầu đó, tùy biến và linh hoạt quản lý những microservice của chúng ta. K8s bao gồm có 2 phần chính gồm master node và worker node. Master node có nhiệm vụ chính là phân phối và điều khiển toàn bộ hệ thống hoạt động, còn worker node là các chương trình ứng dụng thực sự được deploy để chạy. Khi sử dụng K8s thì với một số lượng ít các master node chúng ta có thể điều khiển số lượng worker node lớn hơn rất nhiều.

Trong bài viết này, chúng ta sẽ đồng thời sử dụng một số công cụ nữa như cách tạo instances trên GCP bằng Terraform tool, dùng nginx để làm load balancer trên K8s,...

## Tóm tắt bài viết:  

[1. Tạo các máy ảo trong mô hình trên Google Cloud Platform bằng Terraform ](#createvm)  
[2. Cài đặt K8s cùng với HA ](#k8s)   
[3. Tiến hành cài đặt và cấu hình các node hệ thống](#installandconfigure)  
 - [a. Master Node](#masternode)  
 - [b. Worker Node](#workernode)  

===============================================================  

<a name="createvm"></a>  
## 1. Tạo các máy ảo trong mô hình trên Google Cloud Platform thông qua công cụ Terraform  

**Terraform** là một công cụ mã nguồn mở dùng để tự động hóa quá hình tạo và cấu hình các chương trình hay ứng dụng bằng việc sử dụng các file script được viết sẵn.  

Bây giờ chúng ta sẽ viết một file cấu hình như vậy với tên là `create_vm.tf` để tạo ra các máy ảo cần dùng trên GCP bao gồm `1 máy làm load balancer, 3 máy làm master node và 3 máy làm worker node`. File `create_vm.tf` sẽ được attach cùng với repo này.  
  
[Source Code] https://gist.github.com/shhv212/ec2ed99b502deae4c847189ec43d287f  

Sau khi thực hiện tạo một project riêng trên GCP để làm môi trường thực hành thì ta sẽ tạo thêm 1 Service Account nữa có tên là `terraform` và 1 private key JSON tương ứng với lưu lại thành file để sử dụng tạo các máy ảo.  

<img src="https://i.imgur.com/QCtL8UK.png">  

Vì trong file `create_vm.tf` có gọi đến file JSON nên ta cần đổi tên cho phù hợp. Kết quả thu được tại thư mục sẽ có 2 file như sau:  

<img src="https://i.imgur.com/HW19USt.png">  

Tiếp tục mở `Command Line` lên:

<img src="https://i.imgur.com/Dz3RMjC.png">  

Đầu tiên cần cài đặt `Terraform tool` trước:  

<img src="https://i.imgur.com/NrWM0NQ.png">  

Chúng ta sử dụng lệnh `terraform init` để thiết lập cấu hình ban đầu cho `Terraform`:  

<img src="https://i.imgur.com/EfVNeuC.png">  

Kết quả nhận được sẽ như sau:  

<img src="https://i.imgur.com/Gwu79Lm.png">  

Lệnh `terraform plan` sẽ giúp ta nhìn thấy những tài nguyên nào sẽ được tạo ra trên cơ sở hạ tầng và những tài nguyên cần thiết cho việc đó:  

<img src="https://i.imgur.com/d92H091.png">  

<img src="https://i.imgur.com/0vBz3Mg.png">  

<img src="https://i.imgur.com/UQbSmF0.png">  

Ta thấy rõ ràng các cấu hình của những máy ảo sẽ được tạo ra, bao gồm 7 máy: `1 lb, 3 master và 3 worker`.  

Sau khi xác nhận được các tài nguyên sẽ được tạo ra như thế nào rồi, bây giờ ta có thể dùng lệnh `terraform apply` để tiến hành tạo ra các resource theo đúng kịch bản đã viết:  

<img src="https://i.imgur.com/TK2X485.png">  

Lệnh này cũng giúp ta review lại cấu hình 1 lần nữa trước khi ấn `yes` :  

<img src="https://i.imgur.com/tCRrk9q.png">  

Nếu kết quả như sau là thành công tạo ra 7 resource máy ảo:  

<img src="https://i.imgur.com/ftFbwGr.png">  

<img src="https://i.imgur.com/DlqETQc.png">  

Kế đến, ta mở `Google Cloud Dashboard` lên để kiểm tra các instances mới được tạo ra:  

<img src="https://i.imgur.com/g7bLn9y.png">  

Đối với project `K8s-HA-using-kubeadm-on-GCP` có 7 máy ảo theo như kế hoạch ban đầu.

<a name="k8s"></a>  
## 2. Cài đặt K8s cùng với HA  

Bây giờ trước tiên ta thực hiện cài đặt các gói packets liên quan tới `docker` và `kubernetes` trên tất cả các máy node trước.  
Để làm điều này, từ `Cloud Shell` ta ssh vào trong từng máy và cài đặt tương tự nhau:  

<img src="https://i.imgur.com/unY5sEQ.png">  

Những gói packets cần được cài đặt vào như sau:  

```
sudo apt-get update && apt-get install curl apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install docker-ce kubelet kubeadm kubectl -y
```  

Sau khi cài đặt các gói dịch vụ này xong thì ta sẽ cài `nginx` để dùng làm load balancer trên máy lb01.  
SSH vào máy lb01:  

<img src="https://i.imgur.com/mEIARjC.png">  

Cài đặt `nginx` sau đó enable nó lên máy lb01 và kiểm tra:  

<img src="https://i.imgur.com/P90rBmb.png">  

Mở file cấu hình `nginx.conf` sau đó thêm dòng cấu hình này vào cuối file:  

<img src="https://i.imgur.com/XevezdG.png">  

Sau khi cài đặt xong thì tiếp tục cấu hình load balancer của nginx cho 3 máy master node:  

<img src="https://i.imgur.com/rsFDGyF.png">  

Đến lúc này thì ta load lại cấu hình vừa rồi và kiểm tra xem load balancer đã hoạt động hay chưa:  

<img src="https://i.imgur.com/OFPGDqZ.png">  

Với địa chỉ `10.148.0.18` chính là Private IP của máy lb01. Ở đây ta thấy thông báo `succeeded` tức là load balancer đã thành công trong việc phân phối các request đến từng máy master node.  

<a name="installandconfigure"></a>  
## 3. Tiến hành cài đặt và cấu hình các node hệ thống  

<a name="masternode"></a>  
### a. Master Node  

Đầu tiên, ta phải chọn máy master node 01 để làm máy chính trong cụm các máy master.  

Trên máy master01, ta thực hiện như sau:

```
sudo kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs
```
Với `LOAD_BALANCER_DNS` là địa chỉ Private IP load balancer `10.148.0.18` và `LOAD_BALANCER_PORT` là `port 6443` của load balancer.  

Sau đó ta hãy để ý những dòng kết quả trả về và lưu lại để join những master node khác và những worker node vào cụm cluster.  

```
You can now join any number of the control-plane node running the following command on each as root:
kubeadm join 10.148.0.18:6443 --token eejgjq.rfgykyao7z0ryeig \
    --discovery-token-ca-cert-hash sha256:e58430085cd2109101997a867deff4119042406865fbe49c260983847dxxxxxx \
    --control-plane --certificate-key 7351438558e9712144144960a6c3e59894ffcf1d7689d42729752912e9xxxxxx
```
Đoạn phía trên là dùng cho các master node còn lại join vào cụm cluster.  

```
Then you can join any number of worker nodes by running the following on each as root:
kubeadm join 10.148.0.18:6443 --token eejgjq.rfgykyao7z0ryeig \
    --discovery-token-ca-cert-hash sha256:e58430085cd2109101997a867deff4119042406865fbe49c260983847dxxxxxx
```
Còn đoạn tương tự như thế này là dùng để join các worker node vào cluster.  

Sau đó ta nên cấu hình **kubectl** ngay trên máy master01 để sử dụng đẩy các ứng dụng vào cụm Kubernetes cluster cũng như quản trị được cụm này.  

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Bước tiếp theo cần có là chúng ta cài đặt network cho hệ thống K8s này:  

<img src="https://i.imgur.com/D9Y59Z1.png">  

Nếu như xuất hiện output là các pod đang chạy như trên là đã hoàn tất.  

Đến lúc này việc cài đặt master node chỉ còn lại là join 2 máy master node kia vào cả cụm cluster bằng dòng lệnh phía trên ở 2 máy master01 và master02.  

Sau đó ta quay trở lại máy master01 và kiểm tra xem các máy đã chạy trong cụm cluster hay chưa:  

<img src="https://i.imgur.com/8YPdJEd.png">  

Thành công !!!

<a name="workernode"></a>  
### b. Worker Node  

Bây giờ cách làm khá đơn giản là sử dụng dòng lệnh đã lưu lại ở bước trên để join các máy worker01, worker02 và worker03 vào cả cụm cluster là xong thôi.

Trên máy master01 ta kiểm tra:  

<img src="https://i.imgur.com/gauZsFA.png">  

Tất cả các máy đều có trạng thái `READY` tức là đã hoàn thành bước này.  

Bây giờ ta sẽ demo deploy thử một ứng dụng và chạy các dịch vụ liên quan trên máy master01 để xem ứng dụng này có được đẩy qua các máy master còn lại thông qua cụm cluter hay không.

<img src="https://i.imgur.com/chQfG4o.png">  

<img src="https://i.imgur.com/E7hlASX.png">  

Trên máy master01 ta dùng lệnh `curl` để hiển thị nội dung localhost theo địa chỉ máy master02 với port `30278` của dịch vụ `nginx` vừa tạo ra thì ta thấy kết quả là ứng dụng và dịch vụ cũng được chạy như trên máy master01.  

<img src="https://i.imgur.com/4vOjVYA.png">  

<img src="https://i.imgur.com/tG3LBk3.png">  

Như vậy chúng ta đã xây dựng được một mô hình **K8s** có **High Availability** trên nền tảng dịch vụ **Cloud** của **Google**, bây giờ có thể được sử dụng để phát triển những ứng dụng và sản phẩm thật với hệ thống **Kubernetes** này.  
Cảm ơn mọi người đã theo dõi!!

