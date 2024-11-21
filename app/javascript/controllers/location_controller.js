import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['selectedRegionId', 'selectedProvinceId', 'selectedCityId', 'selectedBarangayId']

    connect() {
        console.log("connected")
    }

    fetchProvinces() {
        let target = this.selectedProvinceIdTarget
        $(target).empty();

        let promptOption = document.createElement('option');
        promptOption.value = "";
        promptOption.text = "Select a province";
        promptOption.selected = true;
        target.appendChild(promptOption);

        this.selectedProvinceIdTarget.value = "";

        $.ajax({
            type: 'GET',
            url: '/api/v1/regions/' + this.selectedRegionIdTarget.value + '/provinces',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }


    fetchCities() {
        let target = this.selectedCityIdTarget
        $(target).empty()

        let promptOption = document.createElement('option');
        promptOption.value = "";
        promptOption.text = "Select a city";
        promptOption.selected = true;
        target.appendChild(promptOption);

        this.selectedCityIdTarget.value = "";

        $.ajax({
            type: 'GET',
            url: '/api/v1/provinces/' + this.selectedProvinceIdTarget.value + '/cities',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }

    //
    fetchBarangays() {
        let target = this.selectedBarangayIdTarget
        $(target).empty()

        let promptOption = document.createElement('option');
        promptOption.value = "";
        promptOption.text = "Select a barangay";
        promptOption.selected = true;
        target.appendChild(promptOption);

        this.selectedBarangayIdTarget.value = "";

        $.ajax({
            type: 'GET',
            url: '/api/v1/cities/' + this.selectedCityIdTarget.value + '/barangays',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }
}
