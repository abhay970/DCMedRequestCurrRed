import { LightningElement, api, track } from 'lwc';
import getAccessToken4 from '@salesforce/apex/OAuthExample4.getAccessToken4';
import getEpicPatientId from '@salesforce/apex/EpicPatientIdController.getEpicPatientId';
export default class ListOfMed extends LightningElement {
    @api recordId;
    @track data = [];
    @track error;
    @track currentPage = 1;
    @track itemsPerPage = 5;
    @track totalPages;
    @track hasData = false;
    @track isError = false;
    @track showContent = false;
    connectedCallback() {
        this.loadData();
    }
    loadData() {
        this.data = [];
        this.error = null;
        this.hasData = false;
        this.isError = false;
        this.showContent = false;
        console.log('Loading data...');
        getEpicPatientId({ patientId: this.recordId })
            .then(res => {
                console.log('Epic Patient ID Response:', res);
                if (res) {
                    return getAccessToken4();
                } else {
                    throw new Error('No Epic Patient ID found.');
                }
            })
            .then(result => {
                console.log('Access Token Response:', result);
                this.data = result.data || []; 
                console.log('Data:', this.data);
                this.calculateTotalPages();
                this.hasData = this.data.length > 0;
                this.showContent = this.hasData;
            })
            .catch(error => {
                console.error('Error fetching data:', error);
                this.error = error;
                this.isError = true;
                this.showContent = false; 
            });
    }
    calculateTotalPages() {
        this.totalPages = Math.ceil(this.data.length / this.itemsPerPage);
        console.log('Total Pages:', this.totalPages);
    }
    get pagedData() {
        const start = (this.currentPage - 1) * this.itemsPerPage;
        const end = this.currentPage * this.itemsPerPage;
        const pageData = this.data.slice(start, end);
        console.log('Paged Data:', pageData);
        return pageData;
    }
    get isFirstPage() {
        const isFirst = this.currentPage === 1;
        console.log('Is First Page:', isFirst);
        return isFirst;
    }
    get isLastPage() {
        const isLast = this.currentPage === this.totalPages;
        console.log('Is Last Page:', isLast);
        return isLast;
    }
    prevPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            console.log('Current Page (Previous):', this.currentPage);
        }
    }
    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            console.log('Current Page (Next):', this.currentPage);
        }
    }
}
