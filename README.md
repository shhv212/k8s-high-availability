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
# 1. Tạo các máy ảo trong mô hình trên Google Cloud Platform bằng Terraform  

**Terraform** là một công cụ mã nguồn mở dùng để tự động hóa quá hình tạo và cấu hình các chương trình hay ứng dụng bằng việc sử dụng các file script được viết sẵn.  

Bây giờ chúng ta sẽ viết một file cấu hình như vậy với tên là create_vm.tf để tạo ra các máy ảo cần dùng trên GCP bao gồm 1 máy làm load balancer, 3 máy làm master node và 3 máy làm worker node. File create_vm.tf sẽ được attach cùng với repo này.  
  
https://gist.github.com/shhv212/ec2ed99b502deae4c847189ec43d287f?file=Interface.swift  










